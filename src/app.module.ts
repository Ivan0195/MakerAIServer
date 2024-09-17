import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ManifestMakerModule } from './manifest-maker/manifestMaker.module';

@Module({
  imports: [ManifestMakerModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
