var React = require('react');
var PoolHeader = require('./PoolHeader');
var PoolRow = require('./PoolRow');
var Mui = require('material-ui');
var Paper = Mui.Paper;

var ResourceFamilyPool = React.createClass({

    handleSelectedChannel: function(ch) {
        this.props.onSelectedChannel(ch);
    },

    handleUpdatedMapping: function(resourceMapping) {

        var mapping = this.props.mapping;
        var family = this.props.familyName;
        for(var i in mapping) {
            if(mapping[i].family === family) {
                mapping[i].channels = resourceMapping;
            }
        }
        this.props.onUpdatedMapping(mapping);

    },

    render: function(){

        var self=this;
        var rows=[];
        this.props.resourcesWithChannels.forEach(function(resource) {
            rows.push(<PoolRow
                mapping={self.props.mapping}
                resourceWithChannels={resource}
                channels={self.props.channels}
                selectedChannel={self.props.selectedChannel}
                onSelectedChannel={self.handleSelectedChannel}
                onUpdatedMapping={self.handleUpdatedMapping} />
            );
        });

        return (

            <div className="resource-family-pool">

                <Paper>

                    <table>

                        <thead>

                            <PoolHeader familyName={this.props.familyName} selectedChannel={self.props.selectedChannel} />

                        </thead>

                        <tbody> {rows} </tbody>

                    </table>

                </Paper>


            </div> );

    }

});

module.exports = ResourceFamilyPool;

