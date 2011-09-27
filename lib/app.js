(function() {
  var Category, NodeModule, app, express, mongoose;
  express = require('express');
  mongoose = require('mongoose');
  mongoose.connect('mongodb://localhost/node-toolbox');
  app = express.createServer();
  Category = require('./category');
  NodeModule = require('./node_module');
  app.register('.coffee', require('coffeekup'));
  app.set('view engine', 'jade');
  app.use(express.compiler({
    src: __dirname + '/../public',
    enable: ['sass']
  }));
  app.use(express.static(__dirname + '/../public'));
  app.get('/', function(request, response) {
    return Category.find({}, function(err, categories) {
      return response.render('index', {
        categories: categories
      });
    });
  });
  app.get('/categories/:id', function(request, response) {
    return Category.findById(request.params.id, function(err, category) {
      return response.render('categories/show', {
        category: category
      });
    });
  });
  app.listen(process.env.PORT || 8000);
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
}).call(this);
