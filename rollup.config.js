"use strict";

import commonjs from "@rollup/plugin-commonjs";
import nodeResolve from "@rollup/plugin-node-resolve";
import remove from "rollup-plugin-delete";
import babel from "rollup-plugin-babel";
import { terser } from "rollup-plugin-terser";

export default {
    input: "./src/eslint.config.js",

    plugins: [
        remove({ targets: "./lib" }),
        commonjs(),
        nodeResolve(),
        babel(),
        terser()
    ],

    output: {
        file: "./lib/eslint.config.js",
        format: "cjs"
    }
};
