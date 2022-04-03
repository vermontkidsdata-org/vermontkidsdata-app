"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addAssetSnapshotSerializer = void 0;
function addAssetSnapshotSerializer(account, region) {
    const bucketMatch = new RegExp(`cdk-[0-9a-z]{9}-assets-${account}-${region}`);
    const assetMatch = /[0-9a-f]{64}\.zip/;
    expect.addSnapshotSerializer({
        test: (val) => typeof val === 'string'
            && (val.match(bucketMatch) != null
                || val.match(assetMatch) != null),
        print: (val) => {
            // Substitute both the bucket part and the asset zip part
            let sval = `${val}`;
            sval = sval.replace(bucketMatch, '[ASSET BUCKET]');
            sval = sval.replace(assetMatch, '[ASSET ZIP]');
            return `"${sval}"`;
        }
    });
}
exports.addAssetSnapshotSerializer = addAssetSnapshotSerializer;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiYWRkLXNuYXBzaG90LXNlcmlhbGl6ZXJzLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiYWRkLXNuYXBzaG90LXNlcmlhbGl6ZXJzLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLFNBQWdCLDBCQUEwQixDQUFDLE9BQWUsRUFBRSxNQUFjO0lBQ3hFLE1BQU0sV0FBVyxHQUFHLElBQUksTUFBTSxDQUFDLDBCQUEwQixPQUFPLElBQUksTUFBTSxFQUFFLENBQUMsQ0FBQztJQUM5RSxNQUFNLFVBQVUsR0FBRyxtQkFBbUIsQ0FBQztJQUV2QyxNQUFNLENBQUMscUJBQXFCLENBQUM7UUFDM0IsSUFBSSxFQUFFLENBQUMsR0FBRyxFQUFFLEVBQUUsQ0FBQyxPQUFPLEdBQUcsS0FBSyxRQUFRO2VBQy9CLENBQUMsR0FBRyxDQUFDLEtBQUssQ0FBQyxXQUFXLENBQUMsSUFBSSxJQUFJO21CQUM5QixHQUFHLENBQUMsS0FBSyxDQUFDLFVBQVUsQ0FBQyxJQUFJLElBQUksQ0FBQztRQUN0QyxLQUFLLEVBQUUsQ0FBQyxHQUFHLEVBQUUsRUFBRTtZQUNiLHlEQUF5RDtZQUN6RCxJQUFJLElBQUksR0FBRyxHQUFHLEdBQUcsRUFBRSxDQUFDO1lBQ3BCLElBQUksR0FBRyxJQUFJLENBQUMsT0FBTyxDQUFDLFdBQVcsRUFBRSxnQkFBZ0IsQ0FBQyxDQUFDO1lBQ25ELElBQUksR0FBRyxJQUFJLENBQUMsT0FBTyxDQUFDLFVBQVUsRUFBRSxhQUFhLENBQUMsQ0FBQztZQUMvQyxPQUFPLElBQUksSUFBSSxHQUFHLENBQUM7UUFDckIsQ0FBQztLQUNGLENBQUMsQ0FBQztBQUNMLENBQUM7QUFoQkQsZ0VBZ0JDIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IGZ1bmN0aW9uIGFkZEFzc2V0U25hcHNob3RTZXJpYWxpemVyKGFjY291bnQ6IHN0cmluZywgcmVnaW9uOiBzdHJpbmcpOiB2b2lkIHtcclxuICBjb25zdCBidWNrZXRNYXRjaCA9IG5ldyBSZWdFeHAoYGNkay1bMC05YS16XXs5fS1hc3NldHMtJHthY2NvdW50fS0ke3JlZ2lvbn1gKTtcclxuICBjb25zdCBhc3NldE1hdGNoID0gL1swLTlhLWZdezY0fVxcLnppcC87XHJcblxyXG4gIGV4cGVjdC5hZGRTbmFwc2hvdFNlcmlhbGl6ZXIoe1xyXG4gICAgdGVzdDogKHZhbCkgPT4gdHlwZW9mIHZhbCA9PT0gJ3N0cmluZydcclxuICAgICAgICAmJiAodmFsLm1hdGNoKGJ1Y2tldE1hdGNoKSAhPSBudWxsXHJcbiAgICAgICAgIHx8IHZhbC5tYXRjaChhc3NldE1hdGNoKSAhPSBudWxsKSxcclxuICAgIHByaW50OiAodmFsKSA9PiB7XHJcbiAgICAgIC8vIFN1YnN0aXR1dGUgYm90aCB0aGUgYnVja2V0IHBhcnQgYW5kIHRoZSBhc3NldCB6aXAgcGFydFxyXG4gICAgICBsZXQgc3ZhbCA9IGAke3ZhbH1gO1xyXG4gICAgICBzdmFsID0gc3ZhbC5yZXBsYWNlKGJ1Y2tldE1hdGNoLCAnW0FTU0VUIEJVQ0tFVF0nKTtcclxuICAgICAgc3ZhbCA9IHN2YWwucmVwbGFjZShhc3NldE1hdGNoLCAnW0FTU0VUIFpJUF0nKTtcclxuICAgICAgcmV0dXJuIGBcIiR7c3ZhbH1cImA7XHJcbiAgICB9XHJcbiAgfSk7XHJcbn1cclxuIl19