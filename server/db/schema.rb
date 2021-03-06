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

ActiveRecord::Schema.define(version: 20160207074813) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "stock_symbol"
    t.string   "market_cap"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "company_to_industries", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "industry_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "earnings", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "reporting_date"
    t.string   "fiscal_quarter"
    t.integer  "eps_forecast"
    t.integer  "estimate_count"
    t.datetime "last_year_report_date"
    t.integer  "last_year_eps"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "industries", force: :cascade do |t|
    t.integer  "sector_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "overviews", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "source"
    t.integer  "open"
    t.integer  "range_hi"
    t.integer  "range_lo"
    t.integer  "f2_wk_hi"
    t.integer  "f2_wk_lo"
    t.integer  "market_cap"
    t.integer  "p_e"
    t.integer  "div"
    t.integer  "yield"
    t.integer  "eps"
    t.integer  "shares"
    t.integer  "beta"
    t.integer  "inst_own"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
