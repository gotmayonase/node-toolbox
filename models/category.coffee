mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
NodeModule = require './node_module'

Category = new Schema {
  name: String,
  child_categories: [Category],
  node_modules: [NodeModule]
}

module.exports = mongoose.model('Category', Category);
