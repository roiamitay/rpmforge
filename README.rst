rpmforge
========

Install the RPMForge RPM and GPG key on RHEL 4/5/6/7 or CentOS 4/5/6/7.

This automatically enables the repo.
Set disable: True in the pillar for installation only.


.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``rpmforge``
--------

Installs the GPG key and RPMForge RPM package for the current OS.
