import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_scale: scale.value
    property alias cfg_showPentagrams: pent.checked
    property alias cfg_cellWidth: cell.value

    Kirigami.FormLayout {
        QQC2.SpinBox { id: scale; Kirigami.FormData.label: "Size, %:"; from: 30; to: 150 }
        QQC2.SpinBox { id: cell; Kirigami.FormData.label: "Cell width, px:"; from: 20; to: 120 }
        QQC2.CheckBox { id: pent; text: "Spinning pentagrams" }
    }
}
