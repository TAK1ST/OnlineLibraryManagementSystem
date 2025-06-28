package dao.implement;

import static constant.constance.RECORDS_PER_LOAD;
import dao.interfaces.IUserDAO;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import util.BCrypt;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class UserDAO implements IUserDAO {

    /**
     * Insert new user with hashed password
     */
    public int insertNewUser(String name, String email, String password) {
        int result = 0;
        Connection cn = null;
        PreparedStatement prst = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                System.out.println("Database connected successfully");

                // Hash password before storing
                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

                String sql = "INSERT INTO [dbo].[users] (name, email, password, role, status, avatar) VALUES (?, ?, ?, 'user', 'active', 'NULL')";
                prst = cn.prepareStatement(sql);
                prst.setString(1, name);
                prst.setString(2, email);
                prst.setString(3, hashedPassword);
                result = prst.executeUpdate();

                if (result > 0) {
                    System.out.println("User registered successfully with hashed password");
                }
            }
        } catch (Exception e) {
            System.err.println("Error inserting new user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (prst != null) {
                    prst.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public int getTotalUsers() {
        Connection cn = null;
        Statement st = null;
        ResultSet rs = null;
        int count = 0;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT COUNT(id) FROM [dbo].[users]";
                st = cn.createStatement();
                rs = st.executeQuery(sql);
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return count;
    }

    @Override
    public List<User> getAll() {
        List<User> users = new ArrayList<>();
        Connection cn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [name], [email], [password], [role], [status], [avatar] FROM [dbo].[users]";
                st = cn.createStatement();
                rs = st.executeQuery(sql);

                while (rs != null && rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");

                    users.add(new User(id,
                            name != null ? name : "",
                            email != null ? email : "",
                            password != null ? password : "",
                            role != null ? role : "",
                            status != null ? status : "",
                            avatar != null ? avatar : ""));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return users;
    }

    public List<User> getUserBySearch(String email, String name, int offset) {
        List<User> userList = new ArrayList<>();
        PreparedStatement pr = null;
        ResultSet rs = null;
        Connection cn = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1 ");
                List<Object> parameters = new ArrayList<>();

                if (name != null && !name.trim().isEmpty()) {
                    sql.append(" AND name LIKE ?");
                    parameters.add("%" + name + "%");
                }
                if (email != null && !email.trim().isEmpty()) {
                    sql.append(" AND email LIKE ?");
                    parameters.add("%" + email + "%");
                }
                sql.append(" ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
                parameters.add(offset);
                parameters.add(RECORDS_PER_LOAD);

                pr = cn.prepareStatement(sql.toString());

                for (int i = 0; i < parameters.size(); i++) {
                    pr.setObject(i + 1, parameters.get(i));
                }

                rs = pr.executeQuery();

                while (rs != null && rs.next()) {
                    int id = rs.getInt("id");
                    String userName = rs.getString("name");
                    String userEmail = rs.getString("email");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");

                    userList.add(new User(id,
                            userName != null ? userName : "",
                            userEmail != null ? userEmail : "",
                            password != null ? password : "",
                            role != null ? role : "",
                            status != null ? status : "",
                            avatar != null ? avatar : ""));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pr != null) {
                    pr.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return userList;
    }

    public List<User> getUserLazyPageLoading(int offset) {
        List<User> userList = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pr = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT * FROM users ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                pr = cn.prepareStatement(sql);
                pr.setInt(1, offset);
                pr.setInt(2, RECORDS_PER_LOAD);
                rs = pr.executeQuery();

                while (rs != null && rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");

                    userList.add(new User(id,
                            name != null ? name : "",
                            email != null ? email : "",
                            password != null ? password : "",
                            role != null ? role : "",
                            status != null ? status : "",
                            avatar != null ? avatar : ""));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pr != null) {
                    pr.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return userList;
    }

    /**
     * Get user by email and password with BCrypt verification
     */
    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                // Only search by email first
                String sql = "SELECT id, name, email, password, role, status, avatar FROM dbo.users WHERE email = ?";
                st = cn.prepareStatement(sql);
                st.setString(1, email);

                rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    String hashedPassword = rs.getString("password");

                    System.out.println("Debug - Email: " + email);
                    System.out.println("Debug - Input password: " + password);
                    System.out.println("Debug - Stored hash: " + hashedPassword);
                    System.out.println("Debug - Hash starts with $2a: " + hashedPassword.startsWith("$2a"));

                    // Verify password using BCrypt
                    boolean passwordMatch = BCrypt.checkpw(password, hashedPassword);
                    System.out.println("Debug - Password match: " + passwordMatch);

                    if (passwordMatch) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String role = rs.getString("role");
                        String status = rs.getString("status");
                        String avatar = rs.getString("avatar");
                        result = new User(id, name, email, hashedPassword, role, status, avatar);
                        System.out.println("User authenticated successfully: " + email);
                    } else {
                        System.out.println("Password verification failed for user: " + email);
                        // Try direct comparison for debugging (remove this in production)
                        if (password.equals(hashedPassword)) {
                            System.out.println("DEBUG: Password stored as plaintext!");
                        }
                    }
                } else {
                    System.out.println("No user found with email: " + email);
                }
            }
        } catch (Exception e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    @Override
    public User getId(int id) {
        User user = null;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [name], [email], [password], [role], [status] FROM [dbo].[users] WHERE [id] = ?";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, id);
                rs = pst.executeQuery();

                if (rs != null && rs.next()) {
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");
                    user = new User(id, name, email, password, role, status, avatar);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }

    @Override
    public User getName(String name) {
        User user = null;
        Connection cn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [name], [email], [password], [role], [status] FROM [dbo].[users] WHERE [name] = ?";
                pst = cn.prepareStatement(sql);
                pst.setString(1, name);
                rs = pst.executeQuery();

                if (rs != null && rs.next()) {
                    int id = rs.getInt("id");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");
                    user = new User(id, name, email, password, role, status, avatar);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }

    @Override
    public User getEmail(String email) {
        User result = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT id, name, email, password, role, status FROM dbo.users WHERE email = ?";
                st = cn.prepareStatement(sql);
                st.setString(1, email);
                rs = st.executeQuery();

                if (rs != null && rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
                    String status = rs.getString("status");
                    String avatar = rs.getString("avatar");
                    result = new User(id, name, email, password, role, status, avatar);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    @Override
    public void save(User user) {
        Connection cn = null;
        PreparedStatement pst = null;

        try {
            cn = DBConnection.getConnection();
            if (cn == null) {
                System.out.println("Cannot connect to database");
                return;
            }

            // Hash password before saving
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

            String sql = "INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, ?, ?)";
            pst = cn.prepareStatement(sql);
            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, hashedPassword);
            pst.setString(4, user.getRole());
            pst.setString(5, user.getStatus());

            int rowsInserted = pst.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("User saved successfully with hashed password!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Update user with avatar
     */
    //bat dau sua avatar o day
    public int updateUserProfile(int id, String name, String avatarPath) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {

                String sql = "UPDATE dbo.users SET name = ?, avatar = ? WHERE id = ?";
                st = cn.prepareStatement(sql);
                st.setString(1, name);
                st.setString(2, avatarPath);
                st.setInt(3, id);
                result = st.executeUpdate();

                if (result > 0) {
                    System.out.println("User updated successfully with new avatar");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    @Override
    public void delete(int userId) {
        Connection cn = null;
        PreparedStatement pst = null;

        try {
            cn = DBConnection.getConnection();
            if (cn == null) {
                System.out.println("Cannot connect to database");
                return;
            }

            String sql = "DELETE FROM users WHERE id = ?";
            pst = cn.prepareStatement(sql);
            pst.setInt(1, userId);

            int rowsDeleted = pst.executeUpdate();
            if (rowsDeleted > 0) {
                System.out.println("User deleted successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Test method to verify BCrypt functionality
     */
    public void testBCrypt(String plainPassword) {
        try {
            String hashed = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
            boolean match = BCrypt.checkpw(plainPassword, hashed);

            System.out.println("=== BCrypt Test ===");
            System.out.println("Plain password: " + plainPassword);
            System.out.println("Hashed password: " + hashed);
            System.out.println("Verification result: " + match);
            System.out.println("Hash starts with $2a: " + hashed.startsWith("$2a"));
            System.out.println("==================");
        } catch (Exception e) {
            System.err.println("BCrypt test failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Update user with optional fields and hashed password
     */
    public int updateUser(int userId, String username, String password, String status) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;

        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                StringBuilder sql = new StringBuilder("UPDATE [dbo].[users] SET ");
                List<Object> parameters = new ArrayList<>();

                if (username != null && !username.trim().isEmpty()) {
                    sql.append("[name] = ?, ");
                    parameters.add(username.trim());
                }
                if (password != null && !password.trim().isEmpty()) {
                    sql.append("[password] = ?, ");
                    parameters.add(BCrypt.hashpw(password, BCrypt.gensalt()));
                }
                if (status != null && !status.trim().isEmpty()) {
                    sql.append("[status] = ?, ");
                    parameters.add(status.trim());
                }

                if (parameters.isEmpty()) {
                    return 0; // Nothing to update
                }

                // Remove the last comma and space
                sql.setLength(sql.length() - 2);
                sql.append(" WHERE id = ?");
                parameters.add(userId);

                st = cn.prepareStatement(sql.toString());

                // Set parameters
                for (int i = 0; i < parameters.size(); i++) {
                    st.setObject(i + 1, parameters.get(i));
                }

                result = st.executeUpdate();
                if (result > 0) {
                    System.out.println("User updated successfully");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    //Tuan them function moi o day
    /**
     * Verify user's current password
     *
     * @param userId - ID of the user
     * @param plainPassword - Plain text password to verify
     * @return true if password matches, false otherwise
     */
    public boolean verifyPassword(int userId, String plainPassword) {
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT [password] FROM [dbo].[users] WHERE id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                rs = st.executeQuery();

                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    // Use BCrypt to verify password
                    return BCrypt.checkpw(plainPassword, hashedPassword);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Update user's password with BCrypt hashing
     *
     * @param userId - ID of the user
     * @param newPassword - New plain text password
     * @return number of affected rows (1 if successful, 0 if failed)
     */
    public int updatePassword(int userId, String newPassword) {
        int result = 0;
        Connection cn = null;
        PreparedStatement st = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "UPDATE [dbo].[users] SET [password] = ? WHERE id = ?";
                st = cn.prepareStatement(sql);

                // Hash the new password using BCrypt
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                st.setString(1, hashedPassword);
                st.setInt(2, userId);

                result = st.executeUpdate();
                if (result > 0) {
                    System.out.println("Password updated successfully for user ID: " + userId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

}
