# Deployment Guide

This guide walks you through deploying `hypersonicIntercept` to GitHub and optionally to CRAN.

## Step 1: Set Up GitHub Repository

1. Create a new GitHub repository named `hypersonic-interception`
2. Push this local repository to GitHub:

```bash
cd /path/to/hypersonic-interception
git remote add origin https://github.com/yourusername/hypersonic-interception.git
git branch -M main
git push -u origin main
```

3. Update the GitHub repository URL in `DESCRIPTION` file:
```
URL: https://github.com/yourusername/hypersonic-interception
BugReports: https://github.com/yourusername/hypersonic-interception/issues
```

## Step 2: Enable GitHub Actions

The `.github/workflows/R-CMD-check.yaml` file is already configured. GitHub Actions should automatically:

- Run `R CMD CHECK` on push and pull requests
- Test on Windows, macOS, and Ubuntu
- Run on R release and development versions
- Track code coverage

No additional setup needed—workflows will activate once pushed to GitHub.

## Step 3: Update Package Metadata

Before final deployment, update:

**DESCRIPTION file:**
- Replace `yourusername` with your GitHub username
- Update author email
- Add any additional metadata

**README.md:**
- Update installation instructions with your username
- Add any badges you want (build status, coverage, etc.)

## Step 4: Optional—Publish to CRAN

To submit to CRAN (optional):

1. **Check with R CMD:**
```bash
R CMD CHECK hypersonic-interception/
```

2. **Use devtools to build and check:**
```r
devtools::check()
devtools::build()
```

3. **Submit to CRAN:**
   - Go to https://cran.r-project.org/submit.html
   - Follow the submission guidelines
   - Attach the tarball created by `devtools::build()`

## Step 5: Create Releases

Tag releases in git and push to GitHub:

```bash
git tag -a v0.1.0 -m "Release version 0.1.0"
git push origin v0.1.0
```

GitHub will automatically create a release page. You can also upload built packages from there.

## Step 6: Documentation

The vignettes and roxygen documentation will be built when the package is installed. To build locally:

```r
devtools::document()  # Generate roxygen documentation
devtools::build_vignettes()  # Build vignettes
```

## Next Steps

1. **Add more models** as your research expands
2. **Write additional vignettes** for specific use cases
3. **Add sample data** to the package (in `data/` directory) for users to experiment
4. **Create a citation** file (`inst/CITATION`) for your research
5. **Build a website** using `pkgdown`:

```r
usethis::use_pkgdown()
pkgdown::build_site()
```

## Troubleshooting

- **Tests failing on GitHub Actions?** Check the logs in Actions tab for detailed error messages
- **Package not installing?** Run `devtools::check()` locally to identify issues
- **Documentation missing?** Run `devtools::document()` to regenerate with roxygen2

## Contact & Support

For issues with the package or research, create an issue on GitHub.
