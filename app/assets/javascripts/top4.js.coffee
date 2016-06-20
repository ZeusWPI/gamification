# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('body.top4-page.show').ready ->
  # `repos` and `contributors` are defined before this gets executed

  for [repo, repo_contributors] in d3.zip(repos, contributors)
    do ([repo, repo_contributors]) ->
      # Only select the top 3 contributors and put the rest in and 'other' user
      repo.contributors = repo_contributors[0..2]
      if repo_contributors.length > 3
        repo.contributors.push
          github_name: 'other'
          score: d3.sum(repo_contributors[3..], (d) -> d.score)

      # Calculate offset for contributor bars
      sum = 0
      for contributor in repo.contributors by -1
        do (contributor) ->
          contributor.y0 = sum
          sum += contributor.score

  margin = {top: 20, right: 0, bottom: 30, left: 0}
  width = 600 - margin.right - margin.left
  height = 300 - margin.top - margin.bottom

  x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1)
    .domain(repos.map((d) -> d.name))

  y = d3.scale.linear()
    .range([0, height])
    .domain([0, d3.max(repos, (d) -> d.score)])

  colors = d3.scale.ordinal()
    .range(['#1976d2','#2196f3', '#64b5f6','#bbdefb'])
    .domain([0,1,2,3])

  chart = d3.select('#top-repos')
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  repo_groups = chart.selectAll('g')
    .data(repos)
    .enter().append('g')
    .attr 'transform', (d) ->
      'translate(' + x(d.name) + ',' + (height - y(d.score)) + ')'

  repo_groups.append('rect')
    .attr('class', 'repo-bar')
    .attr('y', (d) -> y(d.score))
    .attr('height', 0)
    .attr('width', x.rangeBand())
    .transition().duration(1000)
    .attr('y', 0)
    .attr('height', (d) -> y(d.score))

  repo_groups.append('text')
    .attr('class', 'repo-label')
    .attr('x', x.rangeBand() / 2)
    .attr('y', '.5em')
    .attr('opacity', 0)
    .text((d) -> d.score)

  contributor_groups = repo_groups.selectAll('.contributor')
    .data((d) -> d.contributors)
    .enter().append('g')
    .attr('class', 'contributor')
    .attr('transform', 'translate(0,' + height + ')')

  # Collapse groups
  repo_groups.each (d) ->
    d3.select(this)
      .selectAll('.contributor')
      .attr('transform', 'translate(0,' + y(d.score) + ')')

  contributor_groups
    .append('rect')
    .attr('class', 'contributor-bar')
    .attr('height', 0)
    .attr('width', x.rangeBand())
    .style('fill', (d, i) -> colors(i))

  contributor_groups
    .filter((d) -> y(d.score) > 15)
    .append('text')
    .attr('class', 'contributor-name')
    .attr('x', x.rangeBand() / 2)
    .attr('y', '1em')
    .text((d) -> d.github_name)

  repo_groups
    .on 'mouseenter', (d) ->
      t = d3.select(this).transition().duration(500)
      # Breakdown
      t.selectAll('.contributor')
        .attr('transform', (d) -> 'translate(0,' + y(d.y0) + ')')
      t.selectAll('.contributor-bar')
        .attr('height', (d) -> y(d.score))
      # Label
      t.select('.repo-label')
        .attr('y', '-.25em')
        .attr('opacity', 1)
    .on 'mouseleave', (d) ->
      t = d3.select(this).transition().duration(500)
      # Breakdown
      t.selectAll('.contributor')
        .attr('transform', 'translate(0,' + y(d.score) + ')')
      t.selectAll('.contributor-bar')
        .attr('height', 0)
      # Label
      t.select('.repo-label')
        .attr('y', '.5em')
        .attr('opacity', 0)

  xAxis = d3.svg.axis()
    .scale(x)
    .orient('bottom')

  repo_name_nodes = chart.append('g')
    .attr('class', 'axis xaxis')
    .attr('transform', 'translate(0,' + height + ')')
    .call(xAxis)
    .selectAll('text')
    .attr('dy', '1em')

  repo_name_on_click = (repo) ->
    (event) ->
      if event.ctrlKey
        window.open(repo.base_uri, '_blank')
      else
        document.location.href = repo.base_uri

  # Add links to repo names in x axis
  d3.zip(repo_name_nodes[0], repos).forEach (tuple) ->
    text_node = $(tuple[0])
    repo = tuple[1]
    text_node
      .css('cursor', 'pointer')
      .hover(
        -> $(this).css('text-decoration', 'underline')
        -> $(this).css('text-decoration', 'inherit')
      )
      .click repo_name_on_click(repo)
