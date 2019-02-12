import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.3 as Kirigami

import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	WeatherStationPickerDialog {
		id: stationPicker

		onAccepted: {
			plasmoid.configuration.source = source
		}
	}

	Kirigami.FormLayout {
		Layout.fillWidth: true

		RowLayout {
			Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label", "Location:")
			Label {
				id: locationDisplay
				Layout.fillWidth: true
				elide: Text.ElideRight

				text: {
					var sourceDetails = plasmoid.configuration.source.split('|')
					if (sourceDetails.length > 2) {
						return i18ndc("plasma_applet_org.kde.plasma.weather",
							"A weather station location and the weather service it comes from", "%1 (%2)",
							sourceDetails[2], sourceDetails[0])
					}
					return i18ndc("plasma_applet_org.kde.plasma.weather", "no weather station", "-")
				}
			}
			Button {
				id: selectButton
				iconName: "edit-find"
				text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Select")
				onClicked: stationPicker.visible = true
			}
		}
		ConfigSpinBox {
			Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label:spinbox", "Update every:")
			configKey: "updateInterval"
			suffix: i18ndc("plasma_applet_org.kde.plasma.weather", "@item:valuesuffix spacing to number + unit (minutes)", " min")
			stepSize: 5
			minimumValue: 30
			maximumValue: 3600
		}


		RowLayout {
			Kirigami.FormData.label: i18n("Font Family:")
			ConfigFontFamily {
				configKey: 'fontFamily'
			}
			ConfigTextFormat {
				boldConfigKey: 'bold'
			}
		}

		ConfigCheckBox {
			configKey: "showBackground"
			text: i18n("Desktop Widget: Show background")
		}

		ConfigCheckBox {
			configKey: "showDailyBackground"
			text: i18n("Show background around each day")
		}

		ConfigSpinBox {
			id: showNumDays
			Kirigami.FormData.label: i18n("Days Visible:")
			configKey: "showNumDays"
			stepSize: 1
			minimumValue: 0
			maximumValue: 14
			
			readonly property bool isShowingAll: showNumDays.configValue == 0

			Rectangle {
				id: showAllRect
				radius: 2 * Kirigami.Units.devicePixelRatio
				color: showNumDays.isShowingAll ? syspal.highlight : syspal.window
				Behavior on color { ColorAnimation { duration: Kirigami.Units.longDuration } }
				implicitWidth: showingAllLabel.implicitWidth + showingAllLabel.anchors.margins*2
				implicitHeight: showingAllLabel.implicitHeight + showingAllLabel.anchors.margins*2

				Label {
					id: showingAllLabel
					anchors.fill: parent
					anchors.margins: 4 * Kirigami.Units.devicePixelRatio
					color: showNumDays.isShowingAll ? syspal.highlightedText : syspal.text
					Behavior on color { ColorAnimation { duration: Kirigami.Units.longDuration } }
					text: i18n("0 = Show all available data")
				}
			}
		}

		ConfigCheckBox {
			configKey: "showWarnings"
			text: i18n("Show weather warnings")
		}
	}

}
