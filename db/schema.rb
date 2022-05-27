# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_24_210620) do

  create_table "bounties", force: :cascade do |t|
    t.integer "absolute_value", null: false
    t.integer "issue_id", null: false
    t.integer "issuer_id", null: false
    t.integer "claimant_id"
    t.integer "claimed_value"
    t.datetime "claimed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["claimant_id"], name: "index_bounties_on_claimant_id"
    t.index ["claimed_at"], name: "index_bounties_on_claimed_at"
    t.index ["issue_id", "issuer_id"], name: "index_bounties_on_issue_id_and_issuer_id"
    t.index ["issue_id"], name: "index_bounties_on_issue_id"
    t.index ["issuer_id"], name: "index_bounties_on_issuer_id"
  end

  create_table "coders", force: :cascade do |t|
    t.string "github_name", null: false
    t.string "full_name", default: "", null: false
    t.string "avatar_url", null: false
    t.string "github_url", null: false
    t.integer "reward_residual", default: 0, null: false
    t.bigint "absolute_bounty_residual", default: 0, null: false
    t.integer "other_score", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["github_name"], name: "index_coders_on_github_name", unique: true
    t.index ["github_url"], name: "index_coders_on_github_url", unique: true
  end

  create_table "commits", force: :cascade do |t|
    t.integer "coder_id"
    t.integer "repository_id"
    t.string "sha", null: false
    t.integer "additions", default: 0, null: false
    t.integer "deletions", default: 0, null: false
    t.datetime "date", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["coder_id"], name: "index_commits_on_coder_id"
    t.index ["date"], name: "index_commits_on_date"
    t.index ["repository_id", "sha"], name: "index_commits_on_repository_id_and_sha", unique: true
    t.index ["repository_id"], name: "index_commits_on_repository_id"
  end

  create_table "git_identities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "coder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["coder_id"], name: "index_git_identities_on_coder_id"
    t.index ["name", "email"], name: "index_git_identities_on_name_and_email", unique: true
  end

  create_table "issues", force: :cascade do |t|
    t.string "github_url", null: false
    t.integer "number", null: false
    t.string "title", default: "Untitled", null: false
    t.integer "issuer_id", null: false
    t.integer "repository_id", null: false
    t.text "labels", null: false
    t.text "body"
    t.integer "assignee_id"
    t.string "milestone"
    t.datetime "opened_at", null: false
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["github_url"], name: "index_issues_on_github_url", unique: true
    t.index ["repository_id", "number"], name: "index_issues_on_repository_id_and_number", unique: true
    t.index ["repository_id"], name: "index_issues_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "github_url", null: false
    t.string "clone_url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_repositories_on_name"
  end

end
