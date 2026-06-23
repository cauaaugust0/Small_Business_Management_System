# Small Business Management System (Flutter)

**Status:** Development

A Flutter-based management system designed for small truck washing businesses.

The goal is to simplify daily operations by providing tools for service registration, record management, reporting, and business analytics.

## Goal

Develop a lightweight management solution capable of:

* Recording daily truck wash services
* Managing vehicles, services, and companies
* Categorizing operations and records
* Generating reports and business dashboards
* Exporting operational data for external analysis

## Current Architecture

The application follows an **offline-first** approach, allowing daily operations to continue without an internet connection.

Data is stored locally using **SQLite**, providing fast access to records and ensuring information remains available even in environments with limited or no network connectivity.

### Database

* Local SQLite database
* Offline data persistence
* No internet connection required for core features

## Implemented Features

### Management

* Vehicle registration
* Service registration
* Company registration

### Daily Operations

* Daily wash registration
* Automatic final price calculation

### History

* Historical records view
* Service tracking and lookup

## Upcoming Features

### Data Management

* Edit existing vehicle records
* Edit existing service records
* Edit existing company records

### Exporting

* Excel spreadsheet export
* CSV export

### Hardware Integration

* Bluetooth thermal printer support
* Receipt printing

### Analytics

* Operational dashboards
* Revenue statistics
* Service statistics
* Category-based reporting

## Roadmap

* [x] Vehicle registration
* [x] Service registration
* [x] Company registration
* [x] Daily wash records
* [x] Final value calculation
* [x] Record history
* [x] SQLite local database
* [x] Offline operation
* [ ] Record editing
* [ ] Bluetooth thermal printer integration
* [ ] Excel export
* [ ] CSV export
* [ ] Dashboards and analytics

## Tech Stack

* Dart
* Flutter
* SQLite

## Notes

This project is currently focused on delivering core functionality and validating business workflows. The application is designed to operate entirely offline, making it suitable for small businesses that require reliable access to operational data regardless of internet availability.

Future development will prioritize reporting, data export capabilities, hardware integration, and user experience improvements.
