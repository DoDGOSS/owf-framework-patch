package org.ozoneplatform.framework.patch;

import java.io.*;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.JarOutputStream;
import java.util.stream.Collectors;

public class Patch {

    private static final String EXT_LIB_ROOT = "^js-lib/ext-4\\.0\\.7/";
    private static final String EXT_PATCH_ROOT = "WEB-INF/classes/public/vendor/ext-4.0.7";

    private static final String USAGE =
            "\nUsage: java -jar owf-patch.jar originalJarPath updateJarPath [patchedJarPath]\n" +
                    "\nRequired arguments:\n" +
                    "  originalJarPath  - input path of the original JAR file (ex: owf-7.17.1.war)\n" +
                    "  updateJarPath    - input path of the update JAR file (ex: owf-7.17.2.0.war)\n" +
                    "\nOptional arguments:\n" +
                    "  patchedJarPath   - output path of the patched JAR file\n" +
                    "                     default: in-place update of updateJarPath, retaining a copy of the update JAR\n" +
                    "                              with '.orig' appended to the filename.\n";

    public static void main(String... args) {
        String originalJarPath;
        String updateJarPath;
        String patchedJarPath;

        boolean inPlaceUpdate = true;

        if (args.length < 2 || args.length > 3) {
            System.out.println(USAGE);
            System.exit(1);
            return;
        }

        originalJarPath = args[0];
        updateJarPath = args[1];
        if (args.length == 3) {
            patchedJarPath = args[2];
            inPlaceUpdate = false;
        } else {
            patchedJarPath = args[1].replaceFirst("\\.war$", "-PATCHED.war");
        }

        File originalFile = new File(originalJarPath);
        File updateFile = new File(updateJarPath);
        File patchedFile = new File(patchedJarPath);

        try {
            update(originalFile, updateFile, patchedFile, inPlaceUpdate);
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
            if (ex.getCause() != null) {
                ex.printStackTrace();
            }
            System.exit(1);
        }
    }

    private static void update(File originalFile, File updateFile, File patchedFile, boolean inPlaceUpdate) {
        List<JarEntry> entries;
        try {
            entries = findEntriesToCopy(originalFile);
        } catch (IOException ex) {
            throw new PatchException(ex, "Failed to read entries from '%s'", originalFile);
        }

        updateJarFile(originalFile, updateFile, patchedFile, entries);

        if (inPlaceUpdate) {
            File updateOrigFile = new File(updateFile.getPath().replaceFirst("\\.war$", ".war.orig"));
            if (!updateFile.renameTo(updateOrigFile)) {
                throw new PatchException("Failed to rename update JAR file from '%s' to '%s", updateFile, updateOrigFile);
            }
            if (!patchedFile.renameTo(updateFile)) {
                throw new PatchException("Failed to rename patched JAR file from '%s' to '%s", patchedFile, updateFile);
            }
        }
    }

    private static List<JarEntry> findEntriesToCopy(File file) throws IOException {
        return new JarFile(file).stream()
                .filter((entry) -> entry.getName().matches(EXT_LIB_ROOT + "[^/]+\\.js$") ||
                        entry.getName().matches(EXT_LIB_ROOT + "resources/css/[^/]+\\.css$") ||
                        entry.getName().matches(EXT_LIB_ROOT + "locale/[^/]+\\.js$"))
                .collect(Collectors.toList());
    }

    private static void updateJarFile(File originalJar, File updateJar, File patchedJar, List<JarEntry> patchEntries) {
        try (JarFile originalJarFile = new JarFile(originalJar);
             JarFile updateJarFile = new JarFile(updateJar);
             JarOutputStream patchedOutputStream = new JarOutputStream(new FileOutputStream(patchedJar))) {

            // Copy all entries from update JAR to patched JAR
            Enumeration<JarEntry> updateJarEntries = updateJarFile.entries();
            while (updateJarEntries.hasMoreElements()) {
                JarEntry entry = updateJarEntries.nextElement();
                patchedOutputStream.putNextEntry(entry);
                try (InputStream updateInputStream = updateJarFile.getInputStream(entry)) {
                    copyStream(updateInputStream, patchedOutputStream);
                }
            }

            // Copy specified entries from original JAR to patched JAR
            for (JarEntry patchEntry : patchEntries) {
                JarEntry newEntry = new JarEntry(EXT_PATCH_ROOT + "/" + patchEntry.getName().replaceFirst(EXT_LIB_ROOT, ""));
                patchedOutputStream.putNextEntry(newEntry);
                try (InputStream patchInputStream = originalJarFile.getInputStream(patchEntry)) {
                    copyStream(patchInputStream, patchedOutputStream);
                }
            }
        }
        catch (Exception ex) {
            throw new PatchException(ex, "Failed to update JAR");
        }
    }

    private static void copyStream(InputStream inputStream, OutputStream outputStream) throws IOException {
        int bytesRead;
        byte[] buffer = new byte[1024];
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
    }

    private static class PatchException extends RuntimeException {
        PatchException(String format, Object... args) {
            super(String.format(format, args));
        }

        PatchException(Throwable cause, String format, Object... args) {
            super(String.format(format, args), cause);
        }
    }

}
