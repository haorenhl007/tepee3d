import QtQuick 2.0
import Qt3D 2.0
import Qt3D.Shapes 2.0

Item3D
{
    id : seriesplugin_item

    position : Qt.vector3d(0, 0, 0)

    property bool isFocused : false;
    property bool addShow : SeriesPlugin.addShow
    property bool consultingEpisode : false
    property int  listviewRotateAngle : 15

    Behavior on listviewRotateAngle {SmoothedAnimation {duration : 750; velocity : 5}}

    // HAS TO BE IMPLEMENTED
    function roomEntered()    {}
    // HAS TO BE IMPLEMENTED
    function roomLeft()    {}
    // HAS TO BE IMPLEMENTED
    function switchToIdleFocusView()    {plugin_base.moveCamera(); isFocused = false}
    // HAS TO BE IMPLEMENTED
    function switchToSelectedFocusView()    {isFocused = false}
    // HAS TO BE IMPLEMENTED
    function switchToFocusedView()
    {
        var eyePos = plugin_base.getRoomPosition();
        eyePos.z += (-10)

        var widgetPos = plugin_base.getRoomPosition();
        widgetPos.x += cube_picture.x
        widgetPos.y += cube_picture.y
        widgetPos.z += cube_picture.z
        plugin_base.moveCamera(eyePos, widgetPos);
        isFocused = true;
        followed_series_view.state = "shows_view"
    }

    Cube
    {
        id : cube_picture
        scale : 3
        effect : cube_effect
        transform : [Rotation3D {id : cube_x_rotate; axis : Qt.vector3d(0, 0, 1); angle : -90},
            Rotation3D {id : cube_y_rotate;axis : Qt.vector3d(0, 1, 0); angle : 45}]
        onClicked : {plugin_base.askForFocusedFocusState()}
    }

    ParallelAnimation
    {
        id : cube_anim_article
        SmoothedAnimation
        {
            target : cube_picture
            property : "scale"
            duration : 1000
            to : 0
            velocity : 1
        }
        SmoothedAnimation
        {
            target : cube_y_rotate
            duration : 750
            property : "angle"
            to : cube_y_rotate.angle >= 360 ? 0 : 360
        }
    }

    ParallelAnimation
    {
        id : cube_anim_article_close
        loops: 1
        SmoothedAnimation
        {
            target : cube_picture
            property : "scale"
            duration : 1000
            to : 5
            velocity : 1
        }
        SmoothedAnimation
        {
            target : cube_y_rotate
            duration : 750
            property : "angle"
            to : cube_y_rotate.angle >= 360 ? 0 : 360
        }
    }


    ParallelAnimation
    {
        id : rotate_cube
        SmoothedAnimation
        {
            target : cube_x_rotate
            duration : 750
            property : "angle"
            to : cube_x_rotate.angle >= 270 ? -90 : 270
        }
        SequentialAnimation
        {
            SmoothedAnimation
            {
                target : cube_picture
                property : "scale"
                duration : 375
                to : 1
                velocity : 1
            }
            SmoothedAnimation
            {
                target : cube_picture
                property : "scale"
                duration : 375
                to : 3
                velocity : 1
            }
        }
        SmoothedAnimation
        {
            target : cube_y_rotate
            duration : 750
            property : "angle"
            to : cube_y_rotate.angle >= 360 ? 0 : 360
        }
    }

    Effect
    {
        id : cube_effect
        color : "white"
        useLighting : false
        blending : true
    }

    Item
    {
        id : followed_series_item
        enabled : isFocused
        opacity : isFocused ? 1 : 0
        width : mainWindow.width
        height : mainWindow.height

        SearchSerie
        {
            id : search_bar_container
            opacity : (addShow) ? 1 : 0
            enabled : opacity === 1
            width : parent.width / 3
            anchors
            {
                top : parent.top
                topMargin : 100
                horizontalCenter : parent.horizontalCenter
                bottom : parent.bottom
                bottomMargin : 100
            }
        }

        Item
        {
            id : followed_series_view
            enabled : opacity === 1
            opacity : (addShow) ? 0 : 1
            anchors.fill: parent

            states :    [
                State
                {
                    name : "shows_view"
                    PropertyChanges {target: show_view_item; opacity : 1}
                    PropertyChanges {target: season_episode_item; opacity : 0}
                },
                State
                {
                    name : "seasons_shows_view"
                    PropertyChanges {target: show_view_item; opacity : 0}
                    PropertyChanges {target: season_episode_item; opacity : 1}
                }
            ]
            transitions : [Transition { NumberAnimation {duration : 750} }]

            Item
            {
                id : show_view_item
                anchors.fill: parent
                enabled : opacity === 1

                SeriePathView
                {
                    id : show_pathview_container
                    anchors
                    {
                        left : parent.left
                        right : parent.horizontalCenter
                        top : parent.top
                        bottom : parent.verticalCenter
                    }
                }

                SeriesDetailedView
                {
                    id : serie_detailed_view
                    anchors
                    {
                        right : parent.right
                        top : parent.top
                        left : parent.horizontalCenter
                        bottom : parent.bottom
                        leftMargin : 50
                        rightMargin : 50
                        topMargin : 100
                        bottomMargin : 50
                    }
                }
            }


            Item
            {
                id : season_episode_item
                anchors.fill: parent
                enabled : opacity === 1

                SeasonPathView
                {
                    id : season_pathview_container
                    anchors
                    {
                        left : parent.left
                        right : parent.horizontalCenter
                        top : parent.top
                        bottom : parent.bottom
                    }
                }

                DetailedEpisodeView
                {
                    id : detailed_episode_view
                    enabled : (opacity === 1)
                    opacity : (consultingEpisode) ? 1 : 0
                }

                EpisodePathView
                {
                    id : episodes_pathview_container
                    anchors
                    {
                        left : parent.horizontalCenter
                        right : parent.right
                        top : parent.top
                        bottom : parent.bottom
                    }
                }
                BackButton
                {
                    anchors
                    {
                        top : parent.verticalCenter
                        horizontalCenter : parent.horizontalCenter
                        topMargin : 50
                    }
                    onClicked : {followed_series_view.state = "shows_view";}
                }
            }
        }
    }
}