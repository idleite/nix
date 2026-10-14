{ pkgs, ... }:

let
  togglePort = pkgs.writeShellApplication {
    name = "toggle-port";

    runtimeInputs = [
      pkgs.pulseaudio
      pkgs.jq
    ];

    text = ''
      SINK="alsa_output.pci-0000_08_00.4.analog-stereo"

      CURRENT_PORT=$(
        pactl -f json list sinks |
          jq -r --arg sink "$SINK" '
            .[]
            | select(.name == $sink)
            | .active_port
          '
      )

      case "$CURRENT_PORT" in
        analog-output-lineout)
          NEW_PORT="analog-output-headphones"
          ;;

        analog-output-headphones)
          NEW_PORT="analog-output-lineout"
          ;;

        *)
          echo "Error: Unknown current port: $CURRENT_PORT" >&2
          exit 1
          ;;
      esac

      pactl set-sink-port "$SINK" "$NEW_PORT"

      echo "Switched to: $NEW_PORT"
    '';
  };

in
{
  home.packages = [
    togglePort
  ];
}