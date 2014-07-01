# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140630213046) do

  create_table "coders", force: true do |t|
    t.string   "github_name"
    t.string   "full_name"
    t.string   "avatar_url"
    t.integer  "reward_residual"
    t.integer  "bounty_residual"
    t.integer  "commits"
    t.integer  "additions"
    t.integer  "modifications"
    t.integer  "deletions"
    t.integer  "bounty_score"
    t.integer  "other_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
