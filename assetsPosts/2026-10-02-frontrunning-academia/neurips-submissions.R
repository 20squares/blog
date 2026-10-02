# Rebuild with: Rscript --vanilla assetsPosts/2026-10-02-frontrunning-academia/neurips-submissions.R
# Official main-track submission counts, retrieved 2026-10-02.
# 2023: https://media.neurips.cc/Conferences/NeurIPS2023/NeurIPS2023-Fact_Sheet.pdf
# 2024: https://media.neurips.cc/Conferences/NeurIPS2024/NeurIPS2024-Fact_Sheet.pdf
# 2025: https://blog.neurips.cc/2025/09/30/reflections-on-the-2025-review-process-from-the-program-committee-chairs/
# The 2025 report specifies valid submissions. Other tracks are excluded.

script_arg <- grep("^--file=", commandArgs(), value = TRUE)
output_dir <- dirname(normalizePath(sub("^--file=", "", script_arg[[1]])))
years <- c("2023", "2024", "2025")
submissions <- c(12343, 15671, 21575)
growth <- round(100 * (submissions[3] / submissions[1] - 1))

png(file.path(output_dir, "neurips-submissions.png"),
    width = 1600, height = 940, res = 180, bg = "transparent")
par(mar = c(3.1, 4.8, 4.5, 1), family = "sans", fg = "#222222",
    col.axis = "#666666", col.lab = "#333333", las = 1, xaxs = "i", yaxs = "i")
bars <- barplot(submissions, names.arg = years, ylim = c(0, 26000),
                width = 0.7, space = c(0.6, 0.7, 0.7), axes = FALSE,
                col = c("#a8dcd7", "#68c6be", "#20b2aa"), border = NA,
                cex.names = 1.15)
abline(h = seq(0, 25000, 5000), col = "#e2e2e2", lwd = 0.8)
# Draw bars over the grid without drawing the category labels twice.
rect(bars - 0.35, 0, bars + 0.35, submissions,
     col = c("#a8dcd7", "#68c6be", "#20b2aa"), border = NA)
axis(2, at = seq(0, 25000, 5000),
     labels = c("0", "5,000", "10,000", "15,000", "20,000", "25,000"),
     tick = FALSE, cex.axis = 0.95)
text(bars, submissions + 1000, labels = format(submissions, big.mark = ","),
     font = 2, cex = 1.2, col = "#222222")
mtext("NeurIPS main-track submissions", side = 3, line = 2.2,
      adj = 0, cex = 1.4, font = 2, col = "#222222")
mtext(paste0("2023 to 2025: ", growth, "% more submissions in two years"),
      side = 3, line = 0.65, adj = 0, cex = 0.95, col = "#666666")
invisible(dev.off())
