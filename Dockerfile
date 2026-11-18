FROM jupyter/base-notebook:hub-4.0.2

LABEL maintainer="Luka Cehovin Zajc <luka.cehovin@gmail.com>"

USER root

# ffmpeg for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN conda install --yes \
    'ipywidgets==8.1.*' \
    'jupyter_contrib_nbextensions==0.7.*' \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

COPY requirements.txt /tmp/requirements.txt

RUN pip --no-cache-dir install --requirement /tmp/requirements.txt

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

COPY --chown=$NB_UID:$NB_GID jupyter_notebook_config.py /home/$NB_USER/

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/

# Disable Numba because of librosa errors
#ENV NUMBA_DISABLE_JIT=1

USER $NB_UID

