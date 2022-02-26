import { exec } from 'child_process';

export function getBranch(callback: (branch: string) => void): void {
    exec('git rev-parse --abbrev-ref HEAD', (err, stdout, stderr) => {
        if (err) {
            if (err.message.indexOf('not a git repository') >= 0) {
                callback('main');        // Pretend it's just main
            } else {
                console.error(`getBranch Error: <<${err}>>`);
                process.exit(1);
            }
        } else if (typeof stdout === 'string') {
            callback(stdout.trim());
        } else {
            console.error(`getBranch unknown response type`);
            process.exit(1);
        }
    });
}