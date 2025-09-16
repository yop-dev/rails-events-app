# Security Considerations

## Admin Secret Code

This application uses an admin secret code to control admin account creation. For assessment/development purposes, this is currently implemented with a fallback to a hardcoded value.

### Current Implementation
- Uses environment variable `ADMIN_SECRET_CODE` if available
- Falls back to `ADMIN2025SECRET` for development/assessment
- Allows testers/evaluators to easily create admin accounts

### Production Recommendations
For a production deployment, you should:

1. **Set a strong secret code via environment variable:**
   ```bash
   export ADMIN_SECRET_CODE="your-secure-random-32-char-string"
   ```

2. **Remove the hardcoded fallback:**
   ```ruby
   ADMIN_SECRET_CODE = ENV.fetch('ADMIN_SECRET_CODE')
   ```

3. **Use Rails credentials for secrets:**
   ```bash
   rails credentials:edit
   ```

4. **Implement additional security measures:**
   - Rate limiting on admin registration
   - IP allowlisting for admin functions
   - Multi-factor authentication
   - Audit logging for admin actions

### Assessment Context
The current implementation prioritizes:
- Easy testing and evaluation
- Clear demonstration of admin functionality
- Academic/learning purposes

For real-world applications, the production recommendations above would be essential.
