pragma Singleton
import QtQuick

QtObject {
    property string curTheme: "Light"
    property color text: (curTheme === "Light") ? "#0f0c0b" : "#f4f1f0"
    property color background: (curTheme === "Light") ? "#f7f4f3" : "#0c0908"
    property color primary: (curTheme === "Light") ? "#c57049" : "#b6613a"
    property color secondary: (curTheme === "Light") ? "#e2af98" : "#67351d"
    property color accent: (curTheme === "Light") ? "#d6835c" : "#a35029"
    property color shadow: (curTheme === "Light") ? "#80000000" : "#80ffffff"
    property color placeholder: (curTheme === "Light") ? "#80000000" : "#80ffffff"

    // Dégradé secondaire vers fond
    property Gradient gradiantBg: Gradient {
        GradientStop { position: 0.0; color: background }
        GradientStop { position: 1.0; color: secondary }
    }
}
