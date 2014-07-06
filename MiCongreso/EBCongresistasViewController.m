//
//  EBSecondViewController.m
//  MiCongreso
//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBCongresistasViewController.h"

@interface EBCongresistasViewController ()

@end

@implementation EBCongresistasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    senadoresFiltradosDic = [[NSMutableDictionary alloc]init];
    diputadosFiltradosDic = [[NSMutableDictionary alloc]init];
    
    resultados = [[NSMutableDictionary alloc]init];
    
    self.navigationItem.title = @"Congresistas";

    segmented =  [[[[self.childViewControllers objectAtIndex:0]view]subviews]objectAtIndex:0];
    
    [segmented addTarget:self action:@selector(filtrar)
               forControlEvents:UIControlEventValueChanged];
    
    
    diputados = [[NSDictionary alloc]init];
    senadores = [[NSDictionary alloc]init];
    
    downloadManager = [[EBDownloadManager alloc]init];
    downloadManager.delegate = self;
    [downloadManager descargarDiputados];
    [downloadManager descargarSenadores];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    UIImage *icon = [UIImage imageNamed:@"22-location-arrow.png"];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(mostrarCongresistasParaMiUbicacion)];
    [self.navigationItem setRightBarButtonItem:button animated:NO];
    
    
    //Download details 
    /*NSArray *keyS = [senadores allKeys];
    
    for (int i=0; i<keyS.count; i++) {
        NSArray *cForKey = [senadores objectForKey:[keyS objectAtIndex:i]];
        for (EBCongresista *cong in cForKey) {
            [cong descargarDetalles];
        }
    }*/
    
    /*
    NSArray *keyD = [diputados allKeys];
    
    for (int i=0; i<keyD.count; i++) {
        NSArray *cForKey = [diputados objectForKey:[keyD objectAtIndex:i]];
        for (EBCongresista *cong in cForKey) {
            if (!cong.email.length) {
                [cong descargarDetalles];
                NSLog(@"whoops!");
                [NSThread sleepForTimeInterval:3.0];
            }
        }
    }
     
    */
}

-(void)viewDidAppear:(BOOL)animated{
    [self filtrar];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)location{
    [locationManager stopUpdatingLocation];
    //NSLog(@"Location: %@", [location lastObject]);
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:[location lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            //NSLog(@"Placemarks: %@ State: %@", [placemarks objectAtIndex:0], [[placemarks objectAtIndex:0]administrativeArea]);
            NSString *estado = [[placemarks objectAtIndex:0]administrativeArea];
            NSLog(@"Mostrando congresistas de: %@", estado);
            
            EBCongresistasLocationViewController *controller = [[EBCongresistasLocationViewController alloc]initWithStyle:UITableViewStyleGrouped];
            controller.estado = estado;
            controller.diputados = diputados;
            controller.senadores = senadores;
            
            [self.navigationController pushViewController:controller animated:YES];
            
            
        }else if(error) {
            NSLog(@"%@", error);
        }
        
    }];
    
}

-(void)mostrarCongresistasParaMiUbicacion{
    [locationManager startUpdatingLocation];
    
}

-(void)seDescargaronDiputados:(NSDictionary *)diputadosDic{
    diputados = diputadosDic;
    //NSLog(@"Se descargaron diputados %@", diputadosDic);
    
}

-(void)sedescargaronSenadores:(NSDictionary *)senadoresDic{
    senadores = senadoresDic;
    //NSLog(@"Se descargaron senadores %@", senadoresDic);
}

-(void)filtrar{
    diputadosFiltradosCount=0;
    senadoresFiltradosCount=0;
    
    [senadoresFiltradosDic removeAllObjects];
    [diputadosFiltradosDic removeAllObjects];
    
    [resultados removeAllObjects];
    
    //NSLog(@"Changed to %d", segmented.selectedSegmentIndex);
    
    NSArray *partidos = @[@"PRI", @"PAN", @"PRD", @"PVEM", @"NA", @"PT", @"MC"];
    NSString *partido = [partidos objectAtIndex:segmented.selectedSegmentIndex];
    
    
    NSArray *keys = [[senadores allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    int i;
    
    for (i=0; i<[keys count]; i++) {
        NSString *currentKey = [keys objectAtIndex:i];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (EBCongresista *senador in [senadores objectForKey:currentKey]) {
            if ([senador.partido isEqualToString:partido]) {
                [temp addObject:senador];
                senadoresFiltradosCount++;
            }
        }

        if (temp.count) {
            [senadoresFiltradosDic setObject:temp forKey:currentKey];
        }
    }
    
    //NSLog(@"Senadores filtrados: %@", senadoresFiltradosDic);
    
    [resultados addEntriesFromDictionary:senadoresFiltradosDic];
    
    
    NSArray *keysD = [[diputados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (i=0; i<[keysD count]; i++) {
        NSString *currentKey = [keysD objectAtIndex:i];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (EBCongresista *dip in [diputados objectForKey:currentKey]) {
            if ([dip.partido isEqualToString:partido]) {
                [temp addObject:dip];
                diputadosFiltradosCount++;
            }
        }
        if (temp.count) {
            //[diputadosFiltradosDic setObject:temp forKey:currentKey];
            if ([resultados objectForKey:[keysD objectAtIndex:i]]) {
                 NSMutableArray *array = [resultados objectForKey:[keysD objectAtIndex:i]];
                [array addObjectsFromArray:temp];
            }else{
                [resultados setObject:temp forKey:[keysD objectAtIndex:i]];
            }
        }
    }
    
    
    
    
    
    //NSLog(@"Filtrados: %@", senadoresFiltradosDic);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [[[resultados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]objectAtIndex:indexPath.section];
    
    [self performSegueWithIdentifier:@"detailView" sender:[[resultados objectForKey:key]objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detailView"]) {
        EBCongresistaDetailViewController *destination = segue.destinationViewController;
        destination.congresista = sender;
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    // Configure the cell...
    NSString *key = [[[resultados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]objectAtIndex:indexPath.section];
    
    
    cell.textLabel.text = [[[resultados objectForKey:key]objectAtIndex:indexPath.row]nombre];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[resultados allKeys]count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	if (section==[[resultados allKeys]count]-1) {
        return [NSString stringWithFormat:@"Senadores: %d Diputados: %d", senadoresFiltradosCount, diputadosFiltradosCount];
    }else{
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[resultados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[resultados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [[resultados allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return [[resultados objectForKey:[keys objectAtIndex:section]]count];
}




@end
