#!/usr/bin/env bash

set -Eeuo pipefail

vm_name="win11"
viewer_pid=""

# Ensure virt-viewer is installed
if ! command -v virt-viewer &>/dev/null; then
    echo "❌ 'virt-viewer' is not installed. Please install it to use headful mode."
    exit 1
fi

# Cleanup function on Ctrl+C
cleanup() {
    echo -e "\n🧹 Cleaning up..."
    if [[ -n "$viewer_pid" && -e "/proc/$viewer_pid" ]]; then
        echo "⛔ Killing virt-viewer (PID $viewer_pid)..."
        kill "$viewer_pid" || true
    fi

    echo "⏸️ Suspending VM '$vm_name'..."
    virsh suspend "$vm_name" || true

    echo "✅ VM suspended. You can resume it later with: virsh resume $vm_name"
    exit 0
}

trap cleanup INT

# Start or resume VM
if virsh dominfo "$vm_name" &>/dev/null; then
    state=$(virsh domstate "$vm_name")
    case "$state" in
        running)
            echo "✅ VM '$vm_name' is already running."
            ;;
        paused)
            echo "⏯️  VM '$vm_name' is suspended. Resuming..."
            virsh resume "$vm_name"
            ;;
        *)
            echo "▶️  Starting VM '$vm_name'..."
            virsh start "$vm_name"
            ;;
    esac

    echo "🖥️  Launching virt-viewer..."
    virt-viewer --connect qemu:///system "$vm_name" &
    viewer_pid=$!

    echo "📌 Press Ctrl+C to suspend and close the VM."

    # Wait for virt-viewer to exit
    wait "$viewer_pid"
    echo "virt-viewer exited."

    echo "⏸️ Suspending VM '$vm_name'..."
    virsh suspend "$vm_name"
else
    echo "❌ VM '$vm_name' does not exist."
    exit 1
fi
