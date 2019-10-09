FROM jupyter/base-notebook:hub-1.0.0

LABEL maintainer="Luka Cehovin Zajc <luka.cehovin@gmail.com>"

USER root

# ffmpeg for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID
#    'conda-forge::blas=*=openblas' \
# Install Python 3 packages
RUN conda install --quiet --yes \
    'ipywidgets=7.5*' \
    'matplotlib-base=3.1.*' \
    'pandas=0.25*' \
    'scikit-image=0.15*' \
    'scikit-learn=0.21*' \
    'scikit-video=1.1*' \
    'scipy=1.3*' \
    'librosa=0.7' \
    'nltk=3.4.5' \
    'pytorch=1.2*' \
    'torchvision=0.4*' \
    'cpuonly' \
    '-c pytorch' \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

COPY jupyter_notebook_config.py /home/$NB_USER/

USER $NB_UID

