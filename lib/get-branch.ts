import { exec } from 'child_process';

export async function getBranch(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
        exec('git rev-parse --abbrev-ref HEAD', (err, stdout, stderr) => {
            if (err) {
                if (err.message.indexOf('not a git repository') >= 0) {
                    resolve('main');        // Pretend it's just main
                } else {
                    reject(new Error(`getBranch Error: <<${err}>>`));
                }
            } else if (typeof stdout === 'string') {
                resolve(stdout.trim());
            } else {
                reject(new Error(`getBranch unknown response type`));
            }
        });
    });
}
