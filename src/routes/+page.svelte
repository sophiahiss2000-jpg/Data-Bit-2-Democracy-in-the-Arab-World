
<script lang="ts">
	import { onMount } from 'svelte';

	const yearLevels = ["2010-2011", "2012-2014", "2016-2017", "2018-2019", "2021-2022", "2023-2024"];

	const data = [
		{ year: "2010-2011", country: "Algeria", pct: 64.3017120041738 },
		{ year: "2010-2011", country: "Egypt", pct: 71.7458550228065 },
		{ year: "2010-2011", country: "Iraq", pct: 82.704435425601 },
		{ year: "2010-2011", country: "Jordan", pct: 73.2088929308572 },
		{ year: "2010-2011", country: "Lebanon", pct: 81.3532948370519 },
		{ year: "2010-2011", country: "Palestine", pct: 78.3108346549447 },
		{ year: "2010-2011", country: "Saudi Arabia", pct: 53.8906932162342 },
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
		{ year: "2016-2017", country: "Qatar", pct: 69.3609990858193 },
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
		{ year: "2018-2019", country: "Qatar", pct: 63.242522995697 },
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
		{ year: "2021-2022", country: "Mauritania", pct: 75.9838994398797 },
		{ year: "2021-2022", country: "Morocco", pct: 54.4356855560028 },
		{ year: "2021-2022", country: "Palestine", pct: 69.7560512104448 },
		{ year: "2021-2022", country: "Sudan", pct: 69.188480143037 },
		{ year: "2021-2022", country: "Tunisia", pct: 72.4135772828099 },
		{ year: "2023-2024", country: "Iraq", pct: 73.9049389607072 },
		{ year: "2023-2024", country: "Jordan", pct: 84.3403740061869 },
		{ year: "2023-2024", country: "Kuwait", pct: 85.4115314213634 },
		{ year: "2023-2024", country: "Lebanon", pct: 73.8360220863542 },
		{ year: "2023-2024", country: "Mauritania", pct: 76.6301490152746 },
		{ year: "2023-2024", country: "Morocco", pct: 73.1735601501742 },
		{ year: "2023-2024", country: "Palestine", pct: 73.6653206159991 },
		{ year: "2023-2024", country: "Tunisia", pct: 78.7645033360715 }
	];

	const countryColors: Record<string, string> = {
		Algeria: "#19b5d8",
		Egypt: "#ff8c1a",
		Iraq: "#2ca02c",
		Jordan: "#e31a1c",
		Kuwait: "#1565c0",
		Lebanon: "#8c564b",
		Libya: "#ff7f0e",
		Mauritania: "#8e5cc2",
		Morocco: "#1f9d2f",
		Palestine: "#e83e99",
		Qatar: "#1976d2",
		"Saudi Arabia": "#d63384",
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
	minGap = 0.65,
	minY = 50,
	maxY = 87
	) {
	const sorted = [...points]
		.sort((a, b) => a.pct - b.pct)
		.map((d) => ({
			...d,
			originalY: d.pct,
			labelY: d.pct
		}));

	// forward pass: prevent overlap
	for (let i = 1; i < sorted.length; i++) {
		if (sorted[i].labelY - sorted[i - 1].labelY < minGap) {
			sorted[i].labelY = sorted[i - 1].labelY + minGap;
		}
	}

	// if top exceeds bounds, shift whole crowded block downward
	const overflowTop = sorted[sorted.length - 1].labelY - maxY;
	if (overflowTop > 0) {
		for (let i = 0; i < sorted.length; i++) {
			sorted[i].labelY -= overflowTop;
		}
	}

	// if bottom exceeds bounds, shift upward
	const overflowBottom = minY - sorted[0].labelY;
	if (overflowBottom > 0) {
		for (let i = 0; i < sorted.length; i++) {
			sorted[i].labelY += overflowBottom;
		}
	}

	// backward pass: pull labels back toward their actual endpoints
	for (let i = sorted.length - 2; i >= 0; i--) {
		const maxAllowed = sorted[i + 1].labelY - minGap;
		sorted[i].labelY = Math.min(maxAllowed, Math.max(sorted[i].originalY, minY));
	}

	// final forward cleanup
	for (let i = 1; i < sorted.length; i++) {
		if (sorted[i].labelY - sorted[i - 1].labelY < minGap) {
			sorted[i].labelY = sorted[i - 1].labelY + minGap;
		}
	}

	return sorted;
	}

	onMount(async () => {
		const { default: Plotly } = await import('plotly.js-dist-min');

		const traces: any[] = [];
		const countries = [...new Set(data.map((d) => d.country))];

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

		const spreadPoints = spreadLastLabels(lastPoints, 0.9);

		const annotations = spreadPoints.map((d) => ({
			x: d.year,
			y: d.labelY,
			text: d.country,
			showarrow: false,
			xshift: 8,
			xanchor: 'left',
			yanchor: 'middle',
			font: {
				size: 11,
				color: getCountryColor(d.country)
			}
		}));

		const layout: any = {
			xaxis: {
				title: 'Survey wave year',
				tickangle: 45,
				tickmode: 'array',
				tickvals: yearLevels,
				ticktext: yearLevels
			},
			yaxis: {
				title: 'Agreeing respondents (%)',
				range: [50, 87]
			},
			showlegend: false,
			annotations,
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
		The data behind this analysis comes from the 
		<a
		href="https://www.arabbarometer.org/survey-data/#surveys-grid"
		target="_blank"
		rel="noopener noreferrer"
	>  Arab Barometer
	</a>
		,the region’s largest public opinion survey project. Since 2006, it has interviewed more than 135,000 people across 16 countries, using nationally representative samples and face-to-face surveys. At the heart of this analysis is a simple but powerful question: do people believe that <span class="highlight">“democratic systems may have problems, yet they are better than other systems”?</span>  Rather than measuring satisfaction with current politics, the question captures whether demoracy still holds as a general ideal.
	</p>
	<p>
		Support for democracy remains consistently high across much of the Arab world — a finding that is striking given the region’s political developments since 2011. Despite largely disappointing democratic trajectories in the wake of the Arab uprisings — including authoritarian reversals, stalled transitions, and persistent instability — more than two thirds of respondents in most countries continue to express support for democracy as a system of governance. Rather than collapsing, public commitment appears remarkably resilient, even as real-world democratic experiences have often fallen short of expectations.
	</p>

	<div id="plot"></div>

	<p class="caption">
		Figure: Share of respondents agreeing that democracy is the best system (Arab Barometer).
	</p>

	<h2>The surprising story</h2>

	<p>
		Perhaps most surprising, in Tunisia, support for democracy has actually grown since 2011 — even as the country has undergone a profound democratic backslide. Once hailed as the Arab Spring’s only success story, Tunisia has, since 2021, seen a steady concentration of power in the presidency: parliament was suspended, rule by decree became the norm, and a new constitution cemented a hyper-presidential system .
		Institutions that once anchored the democratic transition have been systematically hollowed out. The electoral commission was brought under presidential control, opposition candidates were excluded or even jailed ahead of the 2024 election, and court rulings have been openly ignored. At the same time, journalists, lawyers, and civil society actors have been prosecuted under sweeping laws against “false information,” while opposition figures face arrest on vague charges of “conspiracy against the state.” Public debate has retreated into whispers, and a climate of fear increasingly shapes everyday life. 
		Against this backdrop of shrinking civic space, weakened checks and balances, and growing repression, the persistence — and even rise — of pro-democracy sentiment is striking. It suggests that, for many Tunisians, democracy remains a powerful normative ideal, even as its institutional reality has been progressively dismantled.
	</p>

	<h2>Why this matters</h2>

<p>
	As Tunisia shows, support for democracy is not just an abstract survey response. Even under
	conditions of democratic backsliding, people continue to mobilize and defend the idea of
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
	What this underlines is that civil society in many countries has not given up. Even as institutions are
	being hollowed out, and leaders sabotage accountability mechanisms, a big majority still hold on to the democratic ideal and continue to act on it.
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
</style>