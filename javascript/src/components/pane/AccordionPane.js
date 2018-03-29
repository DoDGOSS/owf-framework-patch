/**
 * @class Ozone.components.pane.AccordionPane
 * @extends Ozone.components.pane.Pane
 */
Ext.define('Ozone.components.pane.AccordionPane', {
    extend: 'Ozone.components.pane.Pane',
    alias: ['widget.accordionpane', 'widget.Ozone.components.pane.AccordionPane'],
    
    plugins: [
        new Ozone.plugins.pane.AccordionPane()
    ],
    
    activeWidget: null,

    defaults: {
        // applied to each contained panel
        xtype: 'widgetpanel',
        layout: 'fit',
        border: true
    },

    /** @see Ozone.components.layout.PinnableAccordion */
    layout: {
        type: 'pinnableaccordion',
        animate: false,
        titleCollapse: false,
        fill: true,
        multi: true
    },

    type: 'accordion',

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
            //width: model.get('width'),
            height: model.get('height'),
            // x: x ? x : model.get('x'),
            // y: y ? y : model.get('y'),
            zIndex: model.get('zIndex'),
            active: model.get('active'),

            autoHeight: false,
            resizable: false,
            draggable: false,
            border: true,
            animCollapse: false,
            split: true,
            closable: true,

            collapsed: false
        });

        //widget = me.insert(Ext.isNumber(launchPosition) ? launchPosition : 0, widgetCfg);
        var widget = Ext.isNumber(launchPosition) ? this.insert(launchPosition, widgetCfg) : this.add(widgetCfg);
        
        widget.on("statesave", function(obj, state) {
            this.defaultSettings.widgetStates = this.defaultSettings.widgetStates || {};
            this.defaultSettings.widgetStates[state.widgetGuid] = {
                "timestamp": Ext.Date.now()
            };
        }, this);

        widget.fireEvent('statesave', widget, { widgetGuid: widget.widgetGuid });
        
        return widget.deferred.promise();
    },
    afterWidgetLaunch: function(widgetCmp, widgetModel) {
        if(widgetModel.get('collapsed')) {
            widgetCmp.collapse();
        }
    },

    maximizeCollapseWidget: function (widget) {
        widget.collapse();
    },

    minimizeExpandWidget: function (widget) {
        widget.expand();
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
    },

    /**
     * @param {Ozone.components.widget.WidgetPanel} widget
     * @param {number} newPosition
     * @param {number} oldPosition
     */
    reorderWidget: function(widget, newPosition, oldPosition) {
        if (oldPosition === null || oldPosition === undefined) {
            oldPosition = this.findWidgetIndex(widget);
        }

        this.move(oldPosition, newPosition);
    }
    
});
