import QtQuick 2.0

Item
{
    id : detail_view_item
    width : mainWindow.width / 2
    height : mainWindow.height/ 2
    x : (mainWindow.width - width) / 2
    property alias title : episodeTitle.text
    property alias summary : episode_overview_text.text
    property alias image_src : episode_delegate_pic.source
    property bool isShown : (opacity > 0.1)

    states : [
        State
        {
            name : "viewShown"
            PropertyChanges {target : detail_view_item; y : (mainWindow.height - detail_view_item.height) / 2}
            when : isShown
        },
        State
        {
            name : "viewHidden"
            PropertyChanges {target : detail_view_item; y : -mainWindow.height}
            when : !isShown
        }
    ]

    transitions : [
        Transition
        {
            SmoothedAnimation {target : detail_view_item; properties : "y"; duration : 750; velocity : 50}
        }
    ]

    Rectangle
    {
        color : "grey"
        opacity : 0.4
        anchors.fill: parent
    }

    Text
    {
        id : episodeTitle
        color : "white"
        width : parent.width -10
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        anchors
        {
            top : parent.top
            left : parent.left
            margins : 10
        }
    }

    Flickable
    {
        clip : true
        anchors
        {
            top : episodeTitle.bottom
            left : parent.left
            right : parent.right
            bottom : close_button.top
            topMargin : 5
            leftMargin : 10
            rightMargin : 10
        }
        Rectangle
        {
            color : "red"
            anchors.fill: parent
        }

        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width - 20
        contentHeight: flickable_item.height
        Item
        {
            id : flickable_item
            width : parent.width
            height: episode_overview_text.height + episode_delegate_pic.height
            Image
            {
                id : episode_delegate_pic
                fillMode : Image.PreserveAspectFit
                asynchronous : true
                width : parent.width - 20
                anchors
                {
                    top : parent.top
                    left : parent.left
                    right : parent.right
                    leftMargin : 20
                    topMargin : 5
                }
                source : img_src
            }

            Text
            {
                id : episode_overview_text
                text : episodeOverview
                width : parent.width - 20
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors
                {
                    top : episode_delegate_pic.bottom
                    topMargin : 5
                }

                color : "white"
                font.pointSize: 12
            }
        }
    }

    CloseButton
    {
        id : close_button
        anchors
        {
            right : parent.right
            bottom : parent.bottom
        }
        onClicked :
        {
            seriesplugin_item.consultingEpisode = !seriesplugin_item.consultingEpisode
        }
    }
}
