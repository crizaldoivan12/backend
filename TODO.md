# Deployment Fix TODO

## Step 1: ✅ Dockerfile Updated
- Added Laravel production setup commands (key:generate, migrate, storage:link, config/route/view:cache)
- Improved Apache VirtualHost config for proper Laravel routing/permissions
- Enhanced permissions (777 on storage/cache)
- Added HEALTHCHECK

## Step 2: ⏳ Update .dockerignore
- Exclude unnecessary files (frontend/, node_modules, .git, etc.)

## Step 3: ⏳ Optionally create entrypoint.sh
- For runtime migrations/env handling if needed

## Step 4: 🔄 USER ACTION - Configure Render
- Add all required env vars (DB_*, APP_KEY, etc.)
- Ensure Postgres DB connected

## Step 5: 🔄 USER ACTION - Test & Deploy
- Local docker test: cd CityHallMonitoringSystem && docker build -t cityhall . && docker run -p 8080:80 cityhall
- Push & redeploy on Render
- Check Render logs
