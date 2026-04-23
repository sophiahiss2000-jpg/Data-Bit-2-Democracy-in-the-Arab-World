<script lang="ts">
    import Papa from 'papaparse';
    import { onMount } from 'svelte';
    import Plotly from 'plotly.js-dist-min';
    import { base } from '$app/paths';

    let chartEl = $state();
    let rawData = $state([] as any[]);
    let waves = $state([] as string[]);
    let selectedIndex = $state(0);

    let selectedWave = $state('');
    let selectedYear = $state('');

    function prepareData(data: any[]) {
        const cleaned = data
            .map((d: any) => ({
                wave: d.wave,
                year: d.year,
                country: d.country,
                pct: Number(d.pct_q516_agree_pct),
                n: Number(d.observations_total)
            }))
            .filter((d: any) => d.wave && d.year && d.country && !Number.isNaN(d.pct));

        const uniqueWaves = [...new Set(cleaned.map((d: any) => d.wave))];

        return { cleaned, uniqueWaves };
    }

    function getWaveData(wave: string) {
        return rawData.filter((d: any) => d.wave === wave);
    }

    function renderMap() {
        if (!chartEl || !waves.length) return;

        selectedWave = waves[selectedIndex];
        const waveData = getWaveData(selectedWave);

        selectedYear = waveData[0]?.year ?? '';

        const trace = {
            type: 'choropleth',
            locationmode: 'country names',
            locations: waveData.map((d: any) => d.country),
            z: waveData.map((d: any) => d.pct),
            text: waveData.map(
                (d: any) =>
                    `<b>${d.country}</b><br>` +
                     `Support for democracy: ${d.pct.toFixed(1)}%<br>` +
                     `N: ${d.n}<br>` +
                     `Wave: ${d.wave}<br>` +
                     `Year: ${d.year}`
            ),
            hoverinfo: 'text',
            colorbar: {
                title: '% agree'
            },
            zmin: 40,
            zmax: 100,
            colorscale: [
                [0, '#f7fbff'],
                [0.2, '#deebf7'],
                [0.4, '#9ecae1'],
                [0.6, '#6baed6'],
                [0.8, '#3182bd'],
                [1, '#08519c']
            ],
            marker: {
                line: {
                    color: 'white',
                    width: 0.5
                }
            }
        };

        const layout = {
            margin: { t: 20, r: 20, b: 20, l: 20 },
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            geo: {
                scope: 'world',
                projection: { type: 'mercator' },
                showframe: false,
                showcoastlines: false,
                showland: true,
                landcolor: '#f5f5f5',
                bgcolor: 'rgba(0,0,0,0)',
                fitbounds: 'locations'
            }
        };

        Plotly.react(chartEl, [trace], layout, {
            responsive: true,
            displayModeBar: false
        });
    }

    function handleSliderChange(event: Event) {
        selectedIndex = Number((event.target as HTMLInputElement).value);
        renderMap();
    }

    onMount(async () => {
        const res = await fetch(`${base}/data/map_data_df.csv`);
        const text = await res.text();

        const parsed = Papa.parse(text, {
            header: true,
            skipEmptyLines: true
        });

        const { cleaned, uniqueWaves } = prepareData(parsed.data);
        rawData = cleaned;
        waves = uniqueWaves;

        renderMap();
    });
</script>

<div class="wrapper">
    <div class="header">
        <h2>Support for democracy across Arab Barometer waves</h2>
        <p>
            Share agreeing that "A democratic system may have problems, yet it is better than
            other systems."
        </p>
    </div>

    {#if waves.length}
        <div class="controls">
            <label for="wave-slider">
                <strong>{selectedWave}</strong>
                <span>{selectedYear}</span>
            </label>

            <input
                id="wave-slider"
                type="range"
                min="0"
                max={waves.length - 1}
                step="1"
                bind:value={selectedIndex}
                oninput={handleSliderChange}
            />

            <div class="ticks">
                {#each waves as wave, i}
                    <button
                        class:selected={i === selectedIndex}
                        onclick={() => {
                            selectedIndex = i;
                            renderMap();
                        }}
                    >
                        {wave}
                    </button>
                {/each}
            </div>
        </div>
    {/if}

    <div bind:this={chartEl} class="chart"></div>
</div>

<style>
    .wrapper {
        max-width: 1000px;
        margin: 0 auto;
        padding: 1.5rem;
        font-family: Corbel, Arial, sans-serif;
    }

    .header {
        margin-bottom: 1rem;
    }

    h2 {
        margin: 0 0 0.4rem 0;
        font-size: 2rem;
        line-height: 1.2;
    }

    p {
        margin: 0;
        color: #444;
        line-height: 1.5;
    }

    .controls {
        margin: 1.2rem 0 1rem 0;
    }

    label {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        font-size: 1rem;
    }

    input[type='range'] {
        width: 100%;
        margin-bottom: 0.8rem;
    }

    .ticks {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
    }

    .ticks button {
        border: 1px solid #ccc;
        background: white;
        padding: 0.35rem 0.6rem;
        border-radius: 999px;
        cursor: pointer;
        font: inherit;
    }

    .ticks button.selected {
        background: #222;
        color: white;
        border-color: #222;
    }

    .chart {
        width: 100%;
        min-height: 620px;
    }
</style>