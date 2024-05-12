/** @type {import("prettier").Config} */
const config = {
    // Use 4 spaces (better for my eyes)
    tabWidth: 4,
    useTabs: false,

    // Add toml plugin
    plugins: ["prettier-plugin-toml"],
};

export default config;
