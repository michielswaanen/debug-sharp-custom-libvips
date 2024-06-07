import sharp from 'sharp';

// Formats that we want to test
const formats = ["heic", "jpeg", "pdf"]

const runTests = async () => {
    console.log("🚀 Testing sharp with direct file reference")

    for (const format of formats) {
        const source = `assets/example.${format}`;
        const output = `output.${format}.jpg`;

        await sharp(source)
            .resize(300, 200)
            .toFile(output, (err, info) => {
                if (err) {
                    console.log(`❌ Error converting ${format}`)
                } else {
                    console.log(`✅ Success converting ${format}`);
                }
            });
    }
}

runTests();