# Support for Democracy in the Arab World Persists

An interactive data story exploring public support for democracy across the Arab world using Arab Barometer survey data.

## View the article
👉 

---

## License

This project uses a dual license:

**Code & Pipeline** — all `.svelte`, `.js`, `.r` files and build scripts are licensed under the [MIT License](LICENSE-CODE).
You are free to use, copy, modify, and distribute the code with attribution.

**Article Content & Data** — the article text, visualisations, and processed dataset (`map_data_df.csv`) are licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/).
You may share the content with attribution, but you may not remix it, adapt it, or use it commercially. Quotation with attribution is permitted under fair use.

> © 2026 Sophia Hiss. Data sourced from Arab Barometer; aggregation and analysis by the author.

---

## Project Summary

This project examines responses to the Arab Barometer question:

*"Democratic systems may have problems, yet they are better than other systems."*

Using survey data across multiple waves (2010–2024), the article visualizes how support for democracy has evolved across countries in the region. Despite democratic backsliding, authoritarian persistence, and conflict, support remains consistently high across much of the Arab world.

A particular focus is placed on Tunisia, where support for democracy has remained resilient even amid institutional erosion and shrinking civic space.

The project also highlights a striking finding: even in countries without a democratic transition experience, such as Algeria, Jordan, and Kuwait, support for democracy remains strong.

## Folder Structure

```text
data-bit-2-sophia/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Pages deployment workflow
├── src/
│   ├── lib/                        # Reusable components (if added)
│   └── routes/
│       ├── +layout.js
│       ├── +layout.svelte
│       └── +page.svelte            # Main article + interactive visualization
├── static/
│   ├── data/
│   │   └── map_data_df.csv         # Processed data file
│   └── robots.txt
├── .vscode/
│   └── extensions.json
├── app.html
├── Q516_ArabBarometer.R            # R code for data cleaning and aggregation
├── package-lock.json
├── .gitignore
└── README.md
```

## Features

- Interactive multi-line chart built with Plotly and Svelte
- Country filter allowing readers to select and compare countries
- Hover tooltips with country-level values by survey wave
- Narrative scrollytelling structure combining analysis and visualization
- Responsive web publication via GitHub Pages

## Data

Source: Arab Barometer Waves II–VIII
https://www.arabbarometer.org/

The visualization uses country-level aggregated shares of respondents agreeing with the democracy support question.

Variable used:
- `pct`: Share of respondents agreeing (%)

Fields:
- `year`
- `country`
- `pct`

## Tools Used

- SvelteKit
- Plotly.js
- R (data cleaning and aggregation)
- GitHub Pages (publishing)

## Files

- `src/routes/+page.svelte` — main article and visualization
- `static/data/` — processed data
- `Q516_ArabBarometer.R` — data cleaning and aggregation pipeline
- `README.md` — project documentation

## Author

Sophia Hiss
Master in International Affairs, Hertie School
Data Journalism, Spring 2026
