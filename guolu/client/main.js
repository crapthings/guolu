class App extends Component {
  state = { nodes: [] }

  componentDidMount() {
    Tracker.autorun(trackerHandler => {
      const subscribeHandler = Meteor.subscribe('nodes')
      if (subscribeHandler.ready()) {
        const nodes = Nodes.find().fetch()
        console.log(nodes)
        this.setState({ nodes })
      }
    })
  }

  toggleNode = node => evt => {
    const { _id, toggle } = node
    Meteor.call('toggleNode', _id, toggle)
  }

  render() {
    const { nodes } = this.state
    return <div>
      {nodes.map((node, idx) => <button
        key={idx}
        style={{ width: '100%', padding: '16px' }}
        onClick={this.toggleNode(node)}
      >
        {node.pin + 1} {node.toggle ? 'on' : 'off'}
      </button>)}
    </div>
  }
}

Meteor.startup(function () {

  const app = document.getElementById('app')
  render(<App />, app)

})
