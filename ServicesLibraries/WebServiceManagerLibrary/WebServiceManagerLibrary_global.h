#ifndef WEBSERVICEMANAGERLIBRARY_GLOBAL_H
#define WEBSERVICEMANAGERLIBRARY_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(WEBSERVICEMANAGERLIBRARY_LIBRARY)
#  define WEBSERVICEMANAGERLIBRARYSHARED_EXPORT Q_DECL_EXPORT
#else
#  define WEBSERVICEMANAGERLIBRARYSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // WEBSERVICEMANAGERLIBRARY_GLOBAL_H
