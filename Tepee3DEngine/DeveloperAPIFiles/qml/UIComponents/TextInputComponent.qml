import QtQuick 2.1

Item
{
    id : textFocusScope

    property alias placeHolder : placeHolderText.text
    property alias echoMode : textInput.echoMode
    property alias text : textInput.text
    signal accepted()
    height : 28

    BorderImage
    {
        id: border
        source: "../Resources/Pictures/text_input_border.png"
        anchors.fill: parent
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    BorderImage
    {
        id: border_selected
        source: "../Resources/Pictures/text_input_border_selected.png"
        anchors.fill: parent
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        opacity : textInput.activeFocus == true ? 1 : 0
        Behavior on opacity {SmoothedAnimation {duration : -1; velocity : 5}}
    }

    Text
    {
        id : placeHolderText
        anchors.fill: parent; anchors.leftMargin: 8
        verticalAlignment: Text.AlignVCenter
        text: "Type something..."
        color: "gray"
        font.italic: true
        visible : textInput.text.length == 0
    }

    TextInput
    {
        id : textInput
        clip : true
        anchors
        {
            left : parent.left
            right : parent.right
            leftMargin : 8
            rightMargin : 8
            verticalCenter : parent.verticalCenter
        }
        selectByMouse: true
        onAccepted: {textFocusScope.accepted(); textInput.focus = false}
    }
}
