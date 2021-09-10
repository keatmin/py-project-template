FROM python:{python_version}-slim AS base

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Install pipenv and compilation dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc

RUN python -m venv /opt/.venv
ENV PATH="/opt/.venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM base AS runtime

# Copy virtual env from python-deps stage
COPY --from=base /opt/.venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Create and switch to a new user
RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

# Install application into container
COPY . .

# Run the executable
ENTRYPOINT ["python", "-m", "{{ project_name }}"]
CMD ["10"]
