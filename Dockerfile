FROM ghcr.io/samvera/hyku/base:latest as hyku-knap-base

# This is specifically NOT $APP_PATH but the parent directory
COPY --chown=1001:101 . /app/samvera
ENV BUNDLE_LOCAL__HYKU_KNAPSACK=/app/samvera
ENV BUNDLE_DISABLE_LOCAL_BRANCH_CHECK=true
RUN ln -sf /app/samvera/branding /app/samvera/hyrax-webapp/public/branding

FROM hyku-knap-base as hyku-web
RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DB_URL='postgresql://fake' bundle exec rake assets:precompile && yarn install
CMD ./bin/web

FROM hyku-web as hyku-worker
CMD ./bin/worker
