# Security

This project is an unofficial local customization and is not affiliated with OpenAI.

The skin does not modify the official Codex application, `app.asar`, or its code signature. It starts the official app with a Chromium DevTools Protocol endpoint bound to the local loopback interface, then injects CSS and decorative DOM into the verified Codex renderer.

CDP is not authenticated against other processes running as the same operating-system user. Install only from a trusted repository or release, avoid running untrusted local software during a themed session, and use the supplied Restore command to close the debugging session when the skin is no longer needed.

Do not publish logs, state files, screenshots containing private tasks, or configuration backups in bug reports. Report security issues privately to the repository maintainer rather than opening a public issue with sensitive data.
