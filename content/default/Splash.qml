import QtQuick 2.2
import QtQuick.Particles 2.0

Item {

	Rectangle {
		id: background;
		anchors.fill: parent;
		color: '#000000';
	}

	ParticleSystem {
		id: sys1;
	}

    ImageParticle {
        system: sys1
        source: 'qrc:///particleresources/glowdot.png'
        color: 'cyan'
        alpha: 0
        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation {
                from: 'cyan'
                to: 'magenta'
                duration: 1000
            }
            ColorAnimation {
                from: 'magenta'
                to: 'blue'
                duration: 2000
            }
            ColorAnimation {
                from: 'blue'
                to: 'violet'
                duration: 2000
            }
            ColorAnimation {
                from: 'violet'
                to: 'cyan'
                duration: 2000
            }
        }
        colorVariation: 0.3
    }

    Emitter {
        id: trailsNormal
        system: sys1

        emitRate: 500
        lifeSpan: 4000

        y: circlePath.cy
        x: circlePath.cx

        velocity: PointDirection { xVariation: 4; yVariation: 4; }
        acceleration: PointDirection {xVariation: 10; yVariation: 10;}
        velocityFromMovement: 8

        size: 16
        sizeVariation: 8
    }

    Item {
        id: circlePath
		property int interval: 1000;
        property real radius: 0
        property real dx: parent.width / 2
        property real dy: parent.height / 2
        property real cx: radius * Math.sin(percent * 6.283185307179) + dx
        property real cy: radius * Math.cos(percent * 6.283185307179) + dy
        property real percent: 0

        SequentialAnimation on percent {
            loops: Animation.Infinite
            running: true

            NumberAnimation {
				duration: circlePath.interval;
				from: 1
				to: 0
				loops: 8
            }

            NumberAnimation {
				duration: circlePath.interval;
				from: 0
				to: 1
				loops: 8
            }

        }

        SequentialAnimation on radius {
            loops: Animation.Infinite
            running: true

            NumberAnimation {
                duration: 4000
                from: 40
                to: 100
            }

            NumberAnimation {
                duration: 4000
                from: 100
                to: 40
            }
        }
    }

	Text {
		anchors.centerIn: parent;
		font.bold: true;
		font.family: 'Helvetica';
		font.pointSize: 18;
		color: '#ffffff';
		text: 'HanGee'
		scale: 0;
		opacity: 0;

		Behavior on opacity {
			NumberAnimation {
				duration: 800;
				easing.type: Easing.OutCubic;
			}
		}

		Behavior on scale {
			NumberAnimation {
				duration: 1000;
				easing.type: Easing.OutBack;
			}
		}

		Component.onCompleted: {
			opacity = 1.0;
			scale = 1.0;
		}
	}
}
