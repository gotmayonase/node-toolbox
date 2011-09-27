express = require('express')
mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/node-toolbox');
app = express.createServer()
Category = require('./category')
NodeModule = require('./node_module')

# Setup Template Engine
app.register '.coffee', require('coffeekup')
app.set 'view engine', 'jade'

# Setup Static Files
app.use express.compiler({ src: __dirname + '/../public', enable: ['sass'] })
app.use express.static(__dirname + '/../public')

# App Routes
app.get '/', (request, response) ->
  Category.find {}, (err, categories) ->
    response.render 'index', {
      categories: categories
    }
    
app.get '/categories/:id', (request, response) ->
  Category.findById request.params.id, (err, category) ->
    response.render 'categories/show', {
      category: category
    }

# Listen
app.listen process.env.PORT || 8000

console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);