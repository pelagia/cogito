import React from 'react'
import PropTypes from 'prop-types'
import { CogitoEthereum } from '@cogitojs/cogito-ethereum'
import { PropValidator } from './PropValidator'

export class CogitoEthereumReact extends React.Component {
  state
  cogitoEthereum

  static propTypes = {
    channelId: PropTypes.string,
    channelKey: function (props, propName, componentName) {
      const prop = props[propName]

      const validator = new PropValidator(prop, propName)

      try {
        validator.validate()
      } catch (e) {
        return e
      }
    },
    appName: PropTypes.string.isRequired,
    contractsBlobs: PropTypes.arrayOf(PropTypes.object).isRequired,
    onTelepathChanged: PropTypes.func,
    render: PropTypes.func
  }

  constructor ({ contractsBlobs }) {
    super()
    this.cogitoEthereum = new CogitoEthereum(contractsBlobs)
    this.state = { cogitoWeb3: null, telepathChannel: null, contractsProxies: null, newChannel: this.newChannel }
  }

  normalizeKey = key => {
    if (key instanceof Uint8Array || key === undefined) {
      return key
    } else {
      return Uint8Array.from(Object.values(key))
    }
  }

  newChannel = async () => {
    const { appName } = this.props
    return this.updateState({
      channelId: undefined,
      channelKey: undefined,
      appName
    })
  }

  updateState = async (props) => {
    const { channelId, channelKey, appName } = props

    const telepathKey = this.normalizeKey(channelKey)

    const {
      cogitoWeb3,
      contractsProxies,
      telepathChannel
    } = await this.cogitoEthereum.getContext({
      channelId,
      channelKey: telepathKey,
      appName
    })

    this.setState({ cogitoWeb3, telepathChannel, contractsProxies })

    this.props.onTelepathChanged && this.props.onTelepathChanged({
      channelId: telepathChannel.id,
      channelKey: telepathChannel.key,
      appName: telepathChannel.appName
    })
  }

  normalize = data => {
    const channelKey = this.normalizeKey(data.channelKey) || ''
    return { ...data, channelKey }
  }

  propsChanged = (prevProps, currentProps) => {
    return prevProps.channelId !== currentProps.channelId ||
      prevProps.channelKey.toString() !== currentProps.channelKey.toString() ||
      prevProps.appName !== currentProps.appName
  }

  currentPropsDifferentFromPrevState = (currentProps, prevState) => {
    return currentProps.channelId !== prevState.telepathChannel.id ||
      currentProps.channelKey !== prevState.telepathChannel.key ||
      currentProps.appName !== prevState.telepathChannel.appName
  }

  componentDidMount () {
    this.updateState(this.props)
  }

  componentDidUpdate (prevProps, prevState) {
    const normalizedPrevProps = this.normalize(prevProps)
    const normalizedCurrentProps = this.normalize(this.props)
    if (this.propsChanged(normalizedPrevProps, normalizedCurrentProps) &&
        this.currentPropsDifferentFromPrevState(normalizedCurrentProps, prevState)) {
      this.updateState(this.props)
    }
  }

  render () {
    return this.props.render
      ? this.props.render(this.state)
      : this.props.children(this.state)
  }
}
