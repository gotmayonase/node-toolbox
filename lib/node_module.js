(function() {
  var NodeModule, ObjectId, Schema, mongoose;
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  NodeModule = new Schema({
    name: String,
    forks: Number,
    watchers: Number,
    active: Boolean,
    description: String,
    pushed_at: Date
  });
  module.exports = NodeModule;
}).call(this);
