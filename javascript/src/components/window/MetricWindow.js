 Ext.define('Ozone.components.window.MetricWindow', {
    extend: 'Ozone.components.window.ModalWindow',
    alias: ['widget.metricwindow', 'widget.Ozone.components.window.MetricWindow'],

    title: 'Metric',
    id: 'metricWindow',
    cls: 'system-window settings-window',
    ui: 'system-window',
    iconCls: 'metric-header-icon',
    layout: 'auto',
    closable: true,
    resizable: false,
    draggable: false,
    modal: true,
    modalAutoClose: true,
    shadow: false,
    autoScroll: false,

    minToolsInRow: 3,
    maxToolsInRow: 5,

    dashboardContainer: null,

    plugins: [
        new Ozone.components.keys.HotKeyComponent(Ozone.components.keys.HotKeys.METRIC),
        new Ozone.components.draggable.DraggableWidgetView({
            itemSelector: '.tool',
            dragNodeSelector: '.thumb-wrap'
        })
    ],

    store: null,

    initComponent: function() {
        var me = this;
        //grab admin widgets to put in window
        me.store = Ext.create('Ext.data.Store', {
            fields: [{name:'name', sortType:Ext.data.SortTypes.asUCString}, 'image', 'guid', 'singleton']
        });
        me.dashboardContainer.activeDashboard.widgetStore.each(function(record) {
            var widgetTypes = record.get('widgetTypes');
            if(widgetTypes.length>0 && widgetTypes[0].name == 'metric' && record.get('definitionVisible')) {
                me.store.add(record);
            }
        });

        me.store.sort('name', 'ASC');

        this.view = Ext.create('Ozone.components.view.ToolDataView', {
            store: this.store,
            multiSelect: false,
            singleSelect: true,
            autoScroll: true,
            listeners: {
                refresh: {
                    fn: this.setupModalFocus,
                    scope: this
                },
                viewready: {
                    fn: this.updateWindowSize,
                    scope: this,
                    single: true
                }
            }
        });

        this.items = [this.view];

        this.on('resize', this.center, this);
        this.callParent(arguments);
    },

    setupModalFocus: function() {
        var view = this.down('tooldataview');
        this.setupFocus(Ext.get(view.getNode(0)), Ext.get(view.getNode(view.store.getCount()-1)));

        Ext.defer(function() {
            var node = view.getNode(0);
            if (node)
                Ext.get(node).focus();
        }, 100);
    },

    callBtnHandler: function(evt, btnText, btn, isKeyPress) {
        this.close();
        this.dashboardContainer.launchWidgets(evt, OWF.Collections.AppComponents.findWhere({name: btnText}), isKeyPress, false);
    },

    updateWindowSize: function(item) {
        var toolWidth, newWidth, tool;

        tool = item.getNode(0);

        if(!tool)
            return;

        var toolEl = Ext.get(tool),
            margin = toolEl.getMargin('r'),
            totalTools = item.getStore().getCount(),
            toolsInRow = 0;

        toolWidth = toolEl.getWidth();

        if (totalTools < this.minToolsInRow) {
            toolsInRow = this.minToolsInRow;
        } else if (totalTools > this.maxToolsInRow) {
            toolsInRow = this.maxToolsInRow;
        } else {
            toolsInRow = totalTools;
        }

        newWidth = (toolWidth + margin) * toolsInRow;

        this.view.doComponentLayout(newWidth);
    }

});
