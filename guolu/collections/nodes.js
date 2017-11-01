Nodes = new Mongo.Collection('nodes')

Meteor.methods({
  toggleNode(_id, toggle) {
    Nodes.update(_id, {
      $set: { toggle: !toggle }
    })
  }
})

if (Meteor.isServer) {

  Meteor.publish('nodes', function () {
    return Nodes.find()
  })

  if (! Nodes.findOne()) {
    _.times(8, n => {
      Nodes.insert({ pin: n })
    })
  }

}
