import sharp from 'sharp';

// Formats that we want to test
const formats = ["heic", "jpeg", "pdf"]

for (const format of formats) {
    const source = `assets/example.${format}`;
    const output = `output.${format}.jpg`;

    sharp(source)
        .resize(300, 200)
        .toFile(output, (err, info) => {
            if (err) {
                console.log(`❌ Error converting ${format}`)
            } else {
                console.log(`✅ Success converting ${format}`);
            }
        });
}