import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Button {
    property alias buttonText: buttonName.text
    property alias buttonSize: buttonName.font.pixelSize
    property alias buttonTextColor: buttonName.color
    Text {
        id: buttonName
        anchors.centerIn: parent
        font.bold: true
        font.pixelSize: 20
    }
    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 50
            radius: buttonName.font.pixelSize / 2
            border.width: control.pressed ?
                              buttonName.font.pixelSize/5
                            : buttonName.font.pixelSize/10
            border.color: (control.hovered ||  control.pressed)
                          ? "#b8d88a" : "#b8c89a"
            gradient: Gradient {
                GradientStop {position: 0.0; color: "#c88716"}
                GradientStop {position: 1.0; color: "#c8b069"}
            }
        }
    }
}
