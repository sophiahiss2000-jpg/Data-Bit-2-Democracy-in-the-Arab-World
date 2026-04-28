
<script lang="ts">
	import { onMount } from 'svelte';
	import { browser } from '$app/environment';

	const yearLevels = ["2010-2011", "2012-2014", "2016-2017", "2018-2019", "2021-2022", "2023-2024"];

	const data = [
		{ year: "2010-2011", country: "Algeria", pct: 64.3017120041738 },
		{ year: "2010-2011", country: "Egypt", pct: 71.7458550228065 },
		{ year: "2010-2011", country: "Iraq", pct: 82.704435425601 },
		{ year: "2010-2011", country: "Jordan", pct: 73.2088929308572 },
		{ year: "2010-2011", country: "Lebanon", pct: 81.3532948370519 },
		{ year: "2010-2011", country: "Palestine", pct: 78.3108346549447 },
		{ year: "2010-2011", country: "Sudan", pct: 72.3046549142979 },
		{ year: "2010-2011", country: "Tunisia", pct: 70.0070153522442 },
		{ year: "2010-2011", country: "Yemen", pct: 72.0023362813357 },
		{ year: "2012-2014", country: "Algeria", pct: 70.22394248858 },
		{ year: "2012-2014", country: "Egypt", pct: 66.3676806658019 },
		{ year: "2012-2014", country: "Iraq", pct: 72.9439660684569 },
		{ year: "2012-2014", country: "Jordan", pct: 70.6000999865208 },
		{ year: "2012-2014", country: "Kuwait", pct: 71.2367890307937 },
		{ year: "2012-2014", country: "Lebanon", pct: 83.2919404074791 },
		{ year: "2012-2014", country: "Libya", pct: 68.8051323175621 },
		{ year: "2012-2014", country: "Morocco", pct: 68.9303309567313 },
		{ year: "2012-2014", country: "Palestine", pct: 78.0105113616199 },
		{ year: "2012-2014", country: "Sudan", pct: 72.7420666742578 },
		{ year: "2012-2014", country: "Tunisia", pct: 70.1658784448216 },
		{ year: "2012-2014", country: "Yemen", pct: 64.925277799584 },
		{ year: "2016-2017", country: "Algeria", pct: 73.5335031674647 },
		{ year: "2016-2017", country: "Jordan", pct: 84.3115489022015 },
		{ year: "2016-2017", country: "Lebanon", pct: 84.4442747772193 },
		{ year: "2016-2017", country: "Morocco", pct: 78.8679491464445 },
		{ year: "2016-2017", country: "Palestine", pct: 74.8573358883765 },
		{ year: "2016-2017", country: "Tunisia", pct: 85.2272720827396 },
		{ year: "2018-2019", country: "Algeria", pct: 69.2047484327144 },
		{ year: "2018-2019", country: "Egypt", pct: 69.8635631547827 },
		{ year: "2018-2019", country: "Iraq", pct: 75.6009117872029 },
		{ year: "2018-2019", country: "Jordan", pct: 84.9611641966437 },
		{ year: "2018-2019", country: "Kuwait", pct: 61.7082494893963 },
		{ year: "2018-2019", country: "Lebanon", pct: 83.160191551661 },
		{ year: "2018-2019", country: "Libya", pct: 73.6130353339379 },
		{ year: "2018-2019", country: "Morocco", pct: 62.7080049409594 },
		{ year: "2018-2019", country: "Palestine", pct: 74.4975012534999 },
		{ year: "2018-2019", country: "Sudan", pct: 70.2174769254966 },
		{ year: "2018-2019", country: "Tunisia", pct: 78.630953707657 },
		{ year: "2018-2019", country: "Yemen", pct: 51.5972174048675 },
		{ year: "2021-2022", country: "Algeria", pct: 73.6458000124198 },
		{ year: "2021-2022", country: "Egypt", pct: 65.4723799883322 },
		{ year: "2021-2022", country: "Iraq", pct: 68.275073606028 },
		{ year: "2021-2022", country: "Jordan", pct: 76.9306599158295 },
		{ year: "2021-2022", country: "Kuwait", pct: 83.9134484910167 },
		{ year: "2021-2022", country: "Lebanon", pct: 80.7687945549717 },
		{ year: "2021-2022", country: "Libya", pct: 69.4289877849287 },
		{ year: "2021-2022", country: "Morocco", pct: 54.4356855560028 },
		{ year: "2021-2022", country: "Palestine", pct: 69.7560512104448 },
		{ year: "2021-2022", country: "Sudan", pct: 69.188480143037 },
		{ year: "2021-2022", country: "Tunisia", pct: 72.4135772828099 },
		{ year: "2023-2024", country: "Iraq", pct: 73.9049389607072 },
		{ year: "2023-2024", country: "Jordan", pct: 84.3403740061869 },
		{ year: "2023-2024", country: "Kuwait", pct: 85.4115314213634 },
		{ year: "2023-2024", country: "Lebanon", pct: 73.8360220863542 },
		{ year: "2023-2024", country: "Morocco", pct: 73.1735601501742 },
		{ year: "2023-2024", country: "Palestine", pct: 73.6653206159991 },
		{ year: "2023-2024", country: "Tunisia", pct: 78.7645033360715 }
	];
	const countries = [...new Set(data.map((d) => d.country))];

		let selectedCountries = $state([...countries]);
		let PlotlyInstance: any;

	const countryColors: Record<string, string> = {
		Algeria: "#19b5d8",
		Egypt: "#ff8c1a",
		Iraq: "#2ca5c",
		Jordan: "#e31a1c",
		Kuwait: "#1565c0",
		Lebanon: "#8c564b",
		Libya: "#4967bd",
		Morocco: "#1f9d2f",
		Palestine: "#e83e99",
		Qatar: "#1976d2",
		Sudan: "#7f7f7f",
		Tunisia: "#b0aa00",
		Yemen: "#12b5d0"
	};

	function getCountryColor(country: string) {
		return countryColors[country] ?? "#444";
	}

	function formatPct(value: number) {
		return `${value.toFixed(1).replace('.', ',')}%`;
	}

	function spreadLastLabels(
	points: { country: string; year: string; pct: number }[],
	minGap = 2.2,
	minY = 20,
	maxY = 100
) {
	const sorted = [...points]
		.sort((a, b) => a.pct - b.pct)
		.map((d) => ({
			...d,
			originalY: d.pct,
			labelY: d.pct
		}));

	for (let i = 1; i < sorted.length; i++) {
		if (sorted[i].labelY - sorted[i - 1].labelY < minGap) {
			sorted[i].labelY = sorted[i - 1].labelY + minGap;
		}
	}

	let overflowTop = sorted[sorted.length - 1].labelY - maxY;
	if (overflowTop > 0) {
		for (const d of sorted) d.labelY -= overflowTop;
	}

	for (let i = sorted.length - 2; i >= 0; i--) {
		if (sorted[i + 1].labelY - sorted[i].labelY < minGap) {
			sorted[i].labelY = sorted[i + 1].labelY - minGap;
		}
	}

	let overflowBottom = minY - sorted[0].labelY;
	if (overflowBottom > 0) {
		for (const d of sorted) d.labelY += overflowBottom;
	}

	return sorted;
}
	function updatePlotVisibility() {
	if (!PlotlyInstance) return;

	const visible = countries.map((country) =>
		selectedCountries.includes(country) ? true : "legendonly"
	);

	PlotlyInstance.restyle("plot", { visible });
}

	function setCountry(country: string, checked: boolean) {
		if (checked) {
			selectedCountries = [...new Set([...selectedCountries, country])];
		} else {
			selectedCountries = selectedCountries.filter((c) => c !== country);
		}

		updatePlotVisibility();
	}

	function showAllCountries() {
		selectedCountries = [...countries];
		updatePlotVisibility();
	}

	function clearAllCountries() {
		selectedCountries = [];
		updatePlotVisibility();
	}
	onMount(async () => {
		if (!browser) return;
		
		const { default: Plotly } = await import('plotly.js-dist-min');
		PlotlyInstance = Plotly;

		const traces: any[] = [];

		countries.forEach((country) => {
			const countryData = data
				.filter((d) => d.country === country)
				.sort((a, b) => yearLevels.indexOf(a.year) - yearLevels.indexOf(b.year));

			const color = getCountryColor(country);

			traces.push({
				x: countryData.map((d) => d.year),
				y: countryData.map((d) => d.pct),
				mode: 'lines+markers',
				name: country,
				line: { width: 2, color },
				marker: { size: 5, color },
				textfont: { color },
				customdata: countryData.map((d) => formatPct(d.pct)),
				hovertemplate: `<b>${country}</b><br>%{customdata}<extra></extra>`
			});
		});

		const lastPoints = countries
			.map((country) => {
				const countryData = data
					.filter((d) => d.country === country)
					.sort((a, b) => yearLevels.indexOf(a.year) - yearLevels.indexOf(b.year));
				return countryData[countryData.length - 1];
			})
			.filter(Boolean);

		const spreadPoints = spreadLastLabels(lastPoints, 3.2, 20, 100);

		const layout: any = {
			xaxis: {
				title: 'Survey wave year',
				type: 'category',
				categoryorder: 'array',
				categoryarray: yearLevels,
				tickangle: 45,
				fixedrange: true
			},
			yaxis: {
				title: 'Agreeing respondents (%)',
				range: [20, 100]
			},
			showlegend: true,
				legend: {
					x: 1.03,
					y: 1,
					xanchor: 'left',
					yanchor: 'top',
					font: { size: 11 }
				},
			margin: { l: 60, r: 170, t: 30, b: 100 },
			font: { size: 13 },
			hovermode: 'closest',
			plot_bgcolor: 'white',
			paper_bgcolor: 'white'
		};

		const config = {
			responsive: true,
			displayModeBar: true
		};

		await Plotly.newPlot('plot', traces, layout, config);
	});
</script>

<div class="article">

	<h1>Support for democracy in the Arab world persists</h1>
	<p class="dek">
		New Arab Barometer data shows diverging but stable optimistic trends across countries over time.
	</p>
	<p>
		15 years after the Arab spring, public commitment to democracy appears remarkably resilient, even as real-world democratic experiences - including democratic backsliding, authoritarian consolidation and persistent instability- have often fallen short of expectations.
	</p>
	<p>
		The data behind this analysis comes from the 
		<a
		href="https://www.arabbarometer.org/survey-data/#surveys-grid"
		target="_blank"
		rel="noopener noreferrer"
	>  Arab Barometer
	</a>
		,the region’s largest public opinion survey project. Since 2006, it has interviewed more than 135,000 people across 16 countries, using nationally representative samples and face-to-face surveys. 
		The team consistently managed to conduct representative surveys with around 2000 respondents per country.
		At the heart of this article is a simple but powerful question: do people believe that <span class="highlight">“democratic systems may have problems, yet they are better than other systems”?</span>  Rather than measuring satisfaction with current politics, the question captures whether demoracy still holds as a general ideal.
	</p>
	<div class="chart-header">
	<h2>Backing for Democracy Remains Consistently Above 50%</h2>

	<p class="chart-subtitle">
		Share of respondents agreeing that democratic systems, despite their problems,
		are better than other forms of government, by survey wave.
	</p>

	<p class="chart-source">
		Source: Arab Barometer Waves II–VIII
	</p>
	</div>
	<div class="country-selector">
	<button onclick={showAllCountries}>All countries</button>
	<button onclick={clearAllCountries}>Clear all</button>

				{#each countries as country (country)}
					<label>
						<input
							type="checkbox"
							checked={selectedCountries.includes(country)}
							onchange={(event) => {
								const input = event.currentTarget as HTMLInputElement;
								setCountry(country, input.checked);
							}}
						/>
						<span style={`color: ${getCountryColor(country)}`}>
							{country}
						</span>
					</label>
				{/each}
			</div>

			<div id="plot"></div>

	<h2>The surprising story</h2>

	<p>
		Strong support for democracy is not limited to countries with
		direct experience of democratic transition. Even societies that have never lived under a fully
		democratic system — such as Algeria, Jordan or Kuwait — show varying but consistently high
		support for democracy compared with other forms of governance. In Jordan and Kuwait, support
		in some waves approaches 90 percent.

	<p>Is this simply wishful thinking — support for an abstract ideal disconnected from political reality?</p>
		
<p>
		Obviously not! If support were merely symbolic, one might expect it to collapse where democratic experiments
		have disappointed. Yet countries that did experience democratic openings and subsequent
		backsliding show similarly resilient patterns. 
		<br>
		<br>
		Tunisia is the clearest example: Here, support for democracy has actually grown since 2011 — even as the country has undergone a profound democratic backslide in recent years. Once hailed as the Arab Spring’s only success story, Tunisia has, since 2021, seen a steady concentration of power in the presidency: the parliament was suspended in 2021, rule by decree became the norm, and the new constitution of 2022 cemented a hyper-presidential system.
		Thus, Institutions that once anchored the democratic transition have been systematically hollowed out since 
		<a href="https://bti-project.org/en/reports/country-report/TUN"
		target="_blank"
		rel="noopener noreferrer"
		> 2021</a>
		,while opposition figures face arrest on vague charges of “conspiracy against the state.” Public debate has retreated into whispers, and a climate of fear increasingly shapes everyday life. 
		The persistence — and even rise — of pro-democracy sentiment therefore is striking. It suggests that, for many Tunisians, democracy remains a powerful normative ideal, even as its institutional reality has been progressively dismantled.
	<p>

	<h2>Why this matters</h2>
	<p>
	As the data shows, even under conditions of democratic backsliding or complete absence of demoratic experience, people continue to mobilize and defend the idea of
	accountability in public life.
</p>

<p>
	This was visible again in 2025 when in the
	<a
		href="https://www.reuters.com/world/tunisians-revive-protests-gabes-over-pollution-state-chemical-plant-2025-12-17/"
		target="_blank"
		rel="noopener noreferrer"
	> southern region of Gabes,
	</a>
	Tunisians returned to the streets in massive protests against policy failures and environmental degradation. These demonstrations were not only about
	environmental harm, but also about neglect and dignity.
</p>

<p>
	What this underlines is that civil society in many countries has not given up.
	Supporting these actors matters, because where democracy is being weakened from above, its
	defence often survives from below.
</p>
</div>

<style>

/* ===== Article ===== */
.article {
	max-width: 720px;
	margin: auto;
	font-family: Georgia, serif;
	line-height: 1.6;
}

h1 {
	font-size: 2.5rem;
	margin-bottom: 0.5rem;
}

.dek {
	font-size: 1.2rem;
	color: #666;
	margin-bottom: 1.5rem;
}
.chart-header {
	margin-top: 2rem;
	margin-bottom: 0.8rem;
	border-top: 2px solid #111;
	padding-top: 0.8rem;
}

.chart-header h2 {
	margin: 0;
	font-size: 1.8rem;
	line-height: 1.2;
	font-weight: 700;
}

.chart-subtitle {
	margin-top: 0.4rem;
	margin-bottom: 0.35rem;
	font-size: 1rem;
	color: #555;
	max-width: 650px;
}

.chart-source {
	margin: 0;
	font-size: 0.8rem;
	color: #888;
	text-transform: uppercase;
	letter-spacing: 0.03em;
}

#plot {
	margin: 2rem 0;
}

.caption {
	font-size: 0.9rem;
	color: #777;
}

h2 {
	margin-top: 2rem;
}
.highlight {
	font-weight: 700;
	color: #d35400c9;
}

/* ===== PLOT ===== */
	.title-wrap {
		margin-bottom: 0.5rem;
	}

	.title-wrap h2 {
		margin: 0;
		font-size: 1.9rem;
		font-weight: 700;
	}

	.title-wrap p {
		margin: 0.25rem 0 0 0;
		color: #666;
		font-size: 1rem;
	}

	#plot {
		width: 120%;
		height: 500px;
	}
	.country-selector {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem 1rem;
		margin: 1.5rem 0 0.5rem 0;
		font-size: 0.85rem;
	}

	.country-selector label {
		display: flex;
		align-items: center;
		gap: 0.25rem;
		cursor: pointer;
	}

	.country-selector button {
		border: 1px solid #ccc;
		background: white;
		padding: 0.25rem 0.6rem;
		border-radius: 4px;
		cursor: pointer;
		font-family: inherit;
	}
</style>