export const port = 7090;

export const enabled = {
    'ipc.js': true,    // (ipc/) IPC over the internet.
    'fileipc.js': false, // (fileipc/) IPC over the local filesystem. Accepts localhost only.
    'exec.js': false,  // (exec/) Execute commands remotely over the internet. Unsafe!
    'loader.js': false // (loader/) Proof of concept of a loader for a private lua script. Example only!
};

//! You might want to change that if TF2 is installed somewhere else
export const tf2_path = 'C:\\Program Files (x86)\\Steam\\steamapps\\common\\Team Fortress 2';