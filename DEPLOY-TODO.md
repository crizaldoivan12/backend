**City Hall Monitoring System - Render Deployment Fix**

## Current Status
- ✅ Docker build succeeds
- ✅ Permissions set
- ✅ storage:link works
- ❌ view:clear fails on Render post-deploy

## Deployment Fix Steps

### 1. [✅] Update entrypoint.sh
✅ Added cache clears after storage:link:
```
php artisan config:clear --quiet || true
php artisan route:clear --quiet || true
php artisan view:clear --quiet || true
```


### 2. [✅] Update Dockerfile
Added:
```
RUN mkdir -p storage/framework/{views,cache,sessions} \
  &amp;&amp; chown -R www-data:www-data /var/www/html \
  &amp;&amp; chmod -R 777 storage bootstrap/cache
```

### 3. [✅] Create render.yaml
```
services:
  - type: web
    env: docker
    dockerfilePath: ./Dockerfile
    autoDeploy: false
```

### 4. [ ] Local Test (User)
```
cd CityHallMonitoringSystem &amp;&amp; docker build -t cityhall . &amp;&amp; docker run -p 8080:80 cityhall
```

### 5. [ ] Render Deploy (User)
- Set env vars
- Push &amp; redeploy

### 6. [ ] Verify
