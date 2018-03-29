/**
 * @class Ozone.components.pane.PortalAnchor
 * @extends Ozone.layout.container.Anchor
 */
Ext.define('Ozone.components.layout.PortalAnchor', {
    extend: 'Ext.layout.container.Anchor',
    alias: ['layout.portalanchor'],

    isValidParent : function(item, target, position) {
        var dom = item.el ? item.el.dom : Ext.getDom(item);
        if (dom && target && target.dom) {

            // Don't need to check for position in portal layout, this may change in the future

            // if (Ext.isNumber(position) && dom !== target.dom.childNodes[position]) {
    //     return false;
    // }

            return (dom.parentNode == (target.dom || target));
        }
        return false;
    }

});

/**
 * @class Ozone.components.pane.PortalPane
 * @extends Ozone.components.pane.Pane
 */
Ext.define('Ozone.components.pane.PortalPane', {
    extend: 'Ozone.components.pane.Pane',
    alias: ['widget.portalpane', 'widget.Ozone.components.pane.PortalPane'],
    
    plugins: [
        new Ozone.plugins.pane.PortalPane()
    ],
    
    activeWidget: null,

    defaults: {
        // applied to each contained panel
        xtype: 'widgetportlet'
    },

    componentCls: 'portalpane pane',

    autoHeight: true,
    autoScroll: true,

    type: 'portal',

    /** @see Ozone.components.widget.WidgetPortlet */
    widgetCls: 'x-portlet',

    /** @see Ozone.components.layout.PortalAnchor */
    layout: 'portalanchor',

    activateWidget: function(widget, showFocusFrame, focusIframe) {
        if(widget.is('backgroundwidget')) { 
            return false; 
        }
        widget.rendered ? widget.expand() : widget.show();
        widget.focus(false, false, showFocusFrame, focusIframe);
        this.dashboard.updateActiveWidget(widget);
        return true;
    },

    launchWidget: function(model, x, y, instanceId, launchData, launchPosition) {
        var widgetCfg = this.createWidgetConfig(model, instanceId, launchData);
        widgetCfg = Ext.Object.merge(widgetCfg, {
            height: model.get('height'),
            width: '100%',
            x: 0,
            y: 0,
            zIndex: 0,
            active: model.get('active'),
            
            maximized: false,
            pinned: false,

            //layout: 'fit',

            collapsed: false
        });
        
        // apply any pane specific default settings if new instance
        if (!model.data.uniqueId) {
            if (this.defaultSettings && this.defaultSettings.widgetStates && this.defaultSettings.widgetStates[widgetCfg.widgetGuid]) {
                var dflt = this.defaultSettings.widgetStates[widgetCfg.widgetGuid];
                widgetCfg = Ext.Object.merge(widgetCfg, {
                    width: dflt.width,
                    height: dflt.height
                });
            }
        }

        //widget = me.insert(Ext.isNumber(launchPosition) ? launchPosition : 0, widgetCfg);
        var widget = Ext.isNumber(launchPosition) ? this.insert(launchPosition, widgetCfg) : this.add(widgetCfg);
        
        widget.on("statesave", function(obj, state) {
            this.defaultSettings.widgetStates = this.defaultSettings.widgetStates || {};
            this.defaultSettings.widgetStates[state.widgetGuid] = {
                "height": state.height,
                "width": state.width,
                "timestamp": Ext.Date.now()
            };
        }, this);
        
        // to fix a bug in Ext, where it doesn't layout if scrollbars are added/removed
        var _this = this;
        widget.on({
            expand: _this.layoutOnExpandCollapse,
            collapse: _this.layoutOnExpandCollapse,
            destroy: _this.layoutOnExpandCollapse,
            scope: _this
        });

        widget.fireEvent('statesave', widget, {
            widgetGuid: widget.widgetGuid,
            height: widget.height,
            width: widget.width
        });
        
        return widget.deferred.promise();
    },

    afterWidgetLaunch: function(widgetCmp, widgetModel) {
        if(widgetModel.get('collapsed')) {
            widgetCmp.collapse();
        }
    },

    layoutOnExpandCollapse: function() {
        if(!this.destroying)
            this.doComponentLayout();
    },

    maximizeCollapseWidget: function (widget) {
        widget.toggleCollapse(true);
    },

    minimizeExpandWidget: function (widget) {
        widget.toggleCollapse(true);
    },

    /**
     * @param {Ozone.components.widget.WidgetPanel} widget
     */
    moveWidgetUp: function (widget) {
        var widgetIndex = this.findWidgetIndex(widget);

        if (widgetIndex > 0) {
            this.reorderWidget(widget, widgetIndex - 1, widgetIndex);
        }
    },

    /**
     * @param {Ozone.components.widget.WidgetPanel} widget
     */
    moveWidgetDown: function (widget) {
        var widgetIndex = this.findWidgetIndex(widget);
        var lastWidgetIndex = this.items.getCount() - 1;

        if (widgetIndex !== -1 && widgetIndex < lastWidgetIndex) {
            this.reorderWidget(widget, widgetIndex + 1, widgetIndex);
        }
    },

    /**
     * @param {Ozone.components.widget.WidgetPanel} widget
     * @returns {number}
     */
    findWidgetIndex: function (widget) {
        return this.items.keys.lastIndexOf(widget.id);
    }
    
});
