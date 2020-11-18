guide1 <- Cicerone$
  new()$
  step(
    el = "hypothesis",
    title = "Data from Calosi",
    description = HTML("Test the hypotheses using the data on beetles. Click on <b>Assumption</b> if not yet done so.")
  )$
  step(
    el = "plotOptions",
    title = "Plot",
    description = "A plot just popped up! "
  )$
  step(
    el = "hyp-wrapper",
    title = "Options",
    description = "Here, you can select what relationship to plot. Now, we only have the option to plot TTR vs LRCP so ."
  )$
  step(
    el = "beetlestats",
    title = "Stats",
    description = HTML("Here shows the stats. Notice that the p-value is colored red since it is less than 0.05, and the trend is significant.
                       The R<sup>2</sup> value tells us that 35% of the variation in thermal tolerance range is explained by the variation in the latitudinal range center point.")
  )$
  step(
    el = "hypothesis",
    title = "Testing the hypotheses",
    description = HTML("Now that the assumption is met, we can check if there is evidence that supports either hypothesis!")
  )


guide2 <- Cicerone$
  new()$
  step(
    el = "Gunderson-wrapper",
    title = "Visualization",
    description = "Let's look at the data on more taxa gathered by Gunderson and Stillman."
  )$
  step(
    el = "taxa-wrapper",
    title = "Selecting taxa",
    description = "Here is the list of taxa that Gunderson and Stillman collected the data for. Keep it at All for now.",
    position = "top"
  )$
  step(
    el = "habitatInput",
    title = "Selecting habitat",
    description = "If you want organisms from specific habitat, here is where you select them.",
    position = "top"
  )$
  step(
    el = "plot",
    title = "Plot",
    description = HTML("Right now, it shows how &Delta; upper thermal limit is affected by the upper thermal limit.
                       Try to find a point at (49.2, 0.06) on the far right. Hovering over it, you see it's a terrestrial crustacean.
                       It has a very high tolerance to heat but has a low acclimatory ability. Let's try to switch up the axes.")
  )$
  step(
    el = "independent-wrapper",
    title = "Independent variable",
    description = "Open the list and select <b>Latitude</b>."
  )$
  step(
    el = "dependent-wrapper",
    title = "Dependent variable",
    description = "Open the tab list select <b>Thermal tolerance range</b>.",
    position = "top"
  )$
  step(
    el = "plot",
    title = "New plot!",
    description = HTML("How does the plot look now? There is a clear upward trend.<br> 
                       It looks like organisms closer to the poles tend to have a wider thermal tolerance range. Let's see if the stats back up the trend.")
  )$
  step(
    el = "stats",
    title = "Stats",
    description = HTML("We can see that the p-value is extremely low, suggesting that the trend is indeed significant.<br>
                       The R<sup>2</sup> value tells us that as much as 32% of the variation in thermal tolerance range is explained by the variation in latitude.<br>
                       Go ahead and test out some other variables!")
  )