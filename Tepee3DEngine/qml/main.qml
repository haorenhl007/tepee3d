//// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.1
import Qt3D 2.0
import Qt3D.Shapes 2.0
import QtQuick.Window 2.1
import "js/RoomManagement.js" as RoomManagement
import "js/Walls.js" as Walls
import "js/CameraManagement.js" as CameraManagement


Viewport
{
    id : mainWindow

    property color menu_background_color : "#404040";
    property color room_list_component_color : "#0099dd";
    property color room_list_selected_component_color : "#0066cc";
    property color plugin_list_component_color : "#0099dd";
    property color plugin_list_selected_component_color : "#0066cc";
    property real  menu_opacity_deployed : 1.0;
    property real  menu_opacity_retracted : 0;
    property int   camera_movement_velocity : 250;
    property int   menuMinimumWidth : 40
    property int   currentRoomId : -1;
    property int   currentRoomFaceId : 0;

    property real   defaultFontSize : 14
    property real   smallFontSize : 12
    property real   largeFontSize : 16

    property alias pluginMenuSource : menu_center.pluginMenuSource
    property variant mouseObjectGrabber : null

    signal roomChanged(int roomId);
    signal roomFaceIdChanged(int roomFaceId);

//    function moveCameraToSkyView()           {CameraManagement.moveCamera(camera, Qt.vector3d(0, 300 + (150 * Math.floor(roomModel.count/ 10)), -200), Qt.vector3d(0, 1, 1), Qt.vector3d(0, 0, 1))}
    function moveCameraToSkyView()           {CameraManagement.moveCamera(camera, Qt.vector3d(0, 100, -200), Qt.vector3d(0, 1, 1), Qt.vector3d(0, 1, 0))}
    function getcurrentIdRoom()              {roomChanged(currentRoomId); return currentRoomId}
    function moveCameraHomeRoom()            {Walls.moveCameraToWall(0)}
    function inRoom()                        {if(currentRoomId <= 0) return false;return true}
    function onRoomSwitch()                  {camera_movement_velocity = 200;currentRoomFaceId = 0;}
    function onRoomFaceSwitch()              {camera_movement_velocity = 100;}
    function postNotification(message)       {notification.sendMessage(message)}


    Component.onCompleted:
    {
        RoomManagement.initialize(camera, roomModel, currentRoomFacesModel);
        moveCameraToSkyView();
        pluginMenuSource = "./Menus/SkyboxPicker.qml"
    }

    onCurrentRoomIdChanged:
    {
        console.log("Room Changed " + currentRoomId)
        roomManager.setCurrentRoom(currentRoomId);
        var room = RoomManagement.findRoomInModel(currentRoomId);
        if (room)
        {
            RoomManagement.moveToRoom(room)
            light.position = room.roomPosition;
        }
        else
        {
            light.position = Qt.vector3d(0, 0, 0);
            pluginMenuSource = "./Menus/SkyboxPicker.qml"
        }
        roomChanged(currentRoomId)
        currentRoomFaceId = 0;
    }

    onCurrentRoomFaceIdChanged:
    {
        console.log("ROOM FACE CHANGED >>>>>>>>>>>>" + currentRoomFaceId)
        Walls.moveCameraToWall(currentRoomFaceId)
        roomFaceIdChanged(currentRoomFaceId)
        // UNSET FOCUS STATE OF PLUGINS
        roomManager.unsetFocusPluginsFromRoom();
    } // NORTH FACE BY DEFAULT, USE FOR CULLING


    //                anchors.fill: parent
//        width : 1280
//        height : 800

    width : Screen.width
    height : Screen.height

    navigation : false
    picking : true     // TO ALLOW MOUSE EVENTS ON 3D ITEMS
    blending : true     // ALLOW TRANSPARENCY
    showPicking : false  // FOR DEBUG PURPOSES ONLY
    objectName : "viewport"

    //               y ^  _
    //                 |  /| z
    //                 | /
    //                 |/
    //      x <--------/---------
    //                /|
    //               / |
    //              /  |
    //

    ListModel    {id : currentRoomFacesModel} // STORES FACES INFORMATION ABOUT THE CURRENT ROOM

    lightModel : LightModel {
        //        model : "OneSided"
        //        viewerPosition : "LocalViewer"
        model : "TwoSided"
        viewerPosition : "ViewerAtInfinity"
        ambientSceneColor : "#ffffff"
    }

    light : Light {
        id : light
        ambientColor : "white";
        diffuseColor : "white"
        specularColor : "white"
        position : Qt.vector3d(0, 0, 0)
        linearAttenuation : 0
        Behavior on position.x {SmoothedAnimation {velocity : 100; duration : -1}}
        Behavior on position.y {SmoothedAnimation {velocity : 100; duration : -1}}
        Behavior on position.z {SmoothedAnimation {velocity : 100; duration : -1}}
    }

    camera: TepeeCamera     {id : camera}

    //    Keys.onLeftPressed:    {}
    //    Keys.onRightPressed:    {}
    //    Keys.onUpPressed:    {}
    //    Keys.onDownPressed:    {}

    Skybox            {source : "Resources/Textures/skyboxes/" + ((roomManager.skyboxPath == "") ? "bridge" : roomManager.skyboxPath)}
    RoomsContainer    {id : roomContainer}
    NotificationManager    {id : notification}
    FpsCounter {}
    MenuCenter        {id : menu_center; anchors.fill : parent}
}

