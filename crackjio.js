var CryptoJS = require("crypto-js"); // npm install crypto-js

let key = '';
let iv = '';

key = CryptoJS.enc.Utf8.parse(key)
iv = CryptoJS.enc.Utf8.parse(iv)

function encrypt(data) {
  let ciphertext = CryptoJS.AES.encrypt(data, key, {iv: iv});
  console.log('ciphertext: ', ciphertext.toString());
  return ciphertext.toString();
}

function decrypt(data) {
  let bytes  = CryptoJS.AES.decrypt(enctext, key, {iv: iv});
  let plaintext = bytes.toString(CryptoJS.enc.Utf8);
  console.log('plaintext: ', plaintext);
  return plaintext;
}



let enctext = 'SnWZON/4KF4CQaHbfL17AA40K05nxr/6Dp1lv6BhLCZWLhE9LBZeSmF3xAKmDkyS';
enctext = '7tW9WIKS3XgExMuRnh36E8ZKdq2VPNeylTRJe9wvmG1H413+V5+V5M+8oZNR+KFA';
enctext = 'Wsu0s3UCVldL7heeoK8tfLZIPfLXw4wyFGvetjr4Kyw=';
enctext = 'LUVp4zKooo45qn5utK/wp9p8Tbegq7eICeIohbEsXqUq6gnN0QT26xfqxe5r1Q2U9hwiFQHsapmYW2q6wFMGHXzaxP0EdFH2uf5unsIzkr/EIfXVcidxLYiq8N4RMd/tPd4GVo1jL31d3QiWPuge1pIv0Y9XYec+PnZemDJIrkKgEjosUmlQKdkKi6m2dV+AHsRoJECOMgoqeDW2DaNNhUm9LHM1oNYByUtZ0ORcsRV0wUIPpb288dpY0DGEyMrIGcLt9uL5Nanv+EL5/BHzp1h7zU4Hd+9V+fulmDZAAnCv2r1NxuDXUVjrMq+PkPKkKWutBSvQWyKIFClIRMr7pnP9gb8E/w4xJVnk4a9gJtVAD4BS6nZ4b77BK+HhHDGufmbFO9RzkygRRp7Rj3TqxJuyzReiUlJ6GBTxp/wdn5qr4W3ceEipcqwYnB4oMCUU';

enctext = "ZqvKQ1XE1kUeqjLyJaQHf2WegB73dsAKq26zEjk64aTTyH2/cSvg6LM+pVCjXR92Qcp/FpZb1L8B\nVTsqNgNy6YNUNMArIR5z6x0w9gX7BBR28ArgF4P6J36f2plrMYHK\n";

enctext = "LmEp8z+EZjz0QjZa4b02AB/41hLcuKbjjZO8FIrQXx9I9zbT9XvKa2iOjFsOVkAp";

enctext = enctext.replace(/\n/g, "")
console.log('enctext: ', enctext);

decrypt(enctext)



